extends CharacterBody2D

# global variables
var SPEED = 400
var ONE_TIME_ANIMATION_FINISHED = true
var CAN_FIRE = true
var PAUSE_UNTIL_NEXT_FIRE = 0
var DIRECTION = null # configured later!
var CAN_FIST_ATTACK = true
var FIST_DAMAGE_POINTS = 1
var ALIEN_BODIES_IN_FIST_RANGE = []
var HEALTH_INCREASE_PER_POWER_UP = 35

# child nodes
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var selected_item_halo = $SelectedItemHalo
@onready var handheld_weapon = $HandheldWeapon
@onready var punch_sound_player = $PunchSoundPlayer

func _ready():
	if OptionsManager.get_options_dict()["selected_item_halo"]:
		selected_item_halo.visible = true
	else:
		selected_item_halo.visible = false
	
	SignalManager.player_was_hit.connect(handle_player_was_hit)
	SignalManager.player_speed_powered_up.connect(handle_speed_power_up)
	SignalManager.player_health_powered_up.connect(handle_heal_power_up)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var attack_props = handle_firing(delta)
	DIRECTION = handle_movement()
	handle_animations(attack_props)

func handle_firing(delta: float) -> Dictionary:
	var animation_name = "shoot" if WeaponManager.equipped_weapon != "fist" else "hit"
	var just_attacked = null
	if Input.is_action_just_pressed("attack") and CAN_FIRE:
		just_attacked = true
		
		if animation_name == "shoot": # implies a weapon is selected
			handheld_weapon.visible = true
			PAUSE_UNTIL_NEXT_FIRE = handheld_weapon.fire()
			CAN_FIRE = false
		else:
			if CAN_FIST_ATTACK:
				SignalManager.player_hit_with_fist.emit()
				var player_direction = "right" # default value till configured below
				if DIRECTION:
					if DIRECTION.x > 0:
						player_direction = "right"
					else:
						player_direction = "left"
						
				# playing the punch sound
				if OptionsManager.get_options_dict()["sound"]:
					punch_sound_player.play()
				
				for body in ALIEN_BODIES_IN_FIST_RANGE:
					var fist_attack_succeeded = body.handle_player_fist_attack(player_direction, FIST_DAMAGE_POINTS)
					if fist_attack_succeeded:
						break
					else:
						continue
	else:
		just_attacked = false
		
	if not CAN_FIRE:
		PAUSE_UNTIL_NEXT_FIRE -= delta
		
		if PAUSE_UNTIL_NEXT_FIRE <= 0:
			CAN_FIRE = true
		
	return {"just_attacked": just_attacked, "animation_name": animation_name}

func handle_movement() -> Vector2:
	# Get input direction
	var direction = Vector2()
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	elif Input.is_action_pressed("move_left"):
		direction.x -= 1
	
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	elif Input.is_action_pressed("move_up"):
		direction.y -= 1

	# Normalize direction and apply speed
	velocity = direction.normalized() * SPEED
	
	# Move the character
	move_and_slide()
	
	# clamping the character to the screen
	var screen_size: Vector2 = get_viewport().size
	position = position.clamp(Vector2.ZERO, screen_size)
	
	GameManager.update_player_position(position)
	
	return direction

func handle_animations(attack_props: Dictionary):
	# ONE_TIME_ANIMATIONS must be played till the end! (e.g. shooting)
	if ONE_TIME_ANIMATION_FINISHED:
		if attack_props["just_attacked"]:
			animated_sprite_2d.play(attack_props["animation_name"])
			ONE_TIME_ANIMATION_FINISHED = false
			# hiding the selected halo if handheld weapon
			if attack_props["animation_name"] != "hit":
				selected_item_halo.visible = false
		elif DIRECTION.x > 0:
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("run")
			
			# changing the side of the handheld weapon
			handheld_weapon.position = Vector2(170, 3.333)
			handheld_weapon.set_direction("right")
		elif DIRECTION.x < 0:
			animated_sprite_2d.flip_h = true
			animated_sprite_2d.play("run")
			
			# changing the side of the handheld weapon
			handheld_weapon.position = Vector2(-170, 3.333)
			handheld_weapon.set_direction("left")
		elif DIRECTION.y != 0:
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")

	# updating the halo sprite to match the selection
	var selected_item_name = InventoryManager.get_current_item()["name"]
	if selected_item_name != "":
		selected_item_halo.animation = selected_item_name
	else:
		selected_item_halo.animation = "empty"

func handle_player_was_hit(hp_points_to_deduct):
	GameManager.player_hp_points -= hp_points_to_deduct
	SignalManager.player_hp_points_updated.emit()
	
	if GameManager.player_hp_points <= 0:
		SignalManager.player_died.emit()
		GameManager.set_game_over()
	else:
		pass

func handle_speed_power_up():
	# the speed is increased by 10%
	SPEED *= 1.1

func handle_heal_power_up():
	var delta_health = GameManager.player_max_hp_points - GameManager.player_hp_points
	if delta_health > HEALTH_INCREASE_PER_POWER_UP:
		GameManager.player_hp_points += HEALTH_INCREASE_PER_POWER_UP
	else:
		GameManager.player_hp_points += delta_health
		
	SignalManager.player_hp_points_updated.emit()

func _on_animation_finished():
	ONE_TIME_ANIMATION_FINISHED = true
	handheld_weapon.visible = false
	if OptionsManager.get_options_dict()["selected_item_halo"]:
		selected_item_halo.visible = true

func _on_fist_attack_range_body_entered(body):
	if body.is_in_group("alien"):
		CAN_FIST_ATTACK = true
		ALIEN_BODIES_IN_FIST_RANGE.append(body)
	else:
		pass

func _on_fist_attack_range_body_exited(body):
	if body.is_in_group("alien"):
		if ALIEN_BODIES_IN_FIST_RANGE.has(body):
			ALIEN_BODIES_IN_FIST_RANGE.erase(body)
			
		if ALIEN_BODIES_IN_FIST_RANGE.size() <= 0:
			CAN_FIST_ATTACK = false
