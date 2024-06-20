extends CharacterBody2D

# global variables
@export var SPEED: int = 400
var ONE_TIME_ANIMATION_FINISHED = true
var CAN_FIRE = true
var PAUSE_UNTIL_NEXT_FIRE = 0

# child nodes
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var selected_item_halo = $SelectedItemHalo
@onready var handheld_weapon = $HandheldWeapon

func _ready():
	GameManager.player_hp_points = LevelManager.get_level_props()["player_hp_points"]
	SignalManager.player_was_hit.connect(handle_player_was_hit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var attack_props = handle_firing(delta)
	var direction = handle_movement()
	handle_animations(attack_props, direction)

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
			CAN_FIRE = true
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

func handle_animations(attack_props: Dictionary, direction: Vector2):
	# ONE_TIME_ANIMATIONS must be played till the end! (e.g. shooting)
	if ONE_TIME_ANIMATION_FINISHED:
		if attack_props["just_attacked"]:
			animated_sprite_2d.play(attack_props["animation_name"])
			ONE_TIME_ANIMATION_FINISHED = false
			# hiding the selected halo if handheld weapon
			if attack_props["animation_name"] != "hit":
				selected_item_halo.visible = false
		elif direction.x > 0:
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("run")
			
			# changing the side of the handheld weapon
			handheld_weapon.position = Vector2(170, 3.333)
			handheld_weapon.set_direction("right")
		elif direction.x < 0:
			animated_sprite_2d.flip_h = true
			animated_sprite_2d.play("run")
			
			# changing the side of the handheld weapon
			handheld_weapon.position = Vector2(-170, 3.333)
			handheld_weapon.set_direction("left")
		elif direction.y != 0:
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")

	# updating the halo sprite to match the selection
	var selected_item_name = InventoryManager.get_current_item()["name"]
	if selected_item_name != "":
		selected_item_halo.animation = selected_item_name
	else:
		selected_item_halo.animation = "empty"

func _on_animation_finished():
	ONE_TIME_ANIMATION_FINISHED = true
	selected_item_halo.visible = true
	handheld_weapon.visible = false

func handle_player_was_hit(hp_points_to_deduct):
	GameManager.player_hp_points -= hp_points_to_deduct
	print(GameManager.player_hp_points)
	if GameManager.player_hp_points <= 0:
		GameManager.set_game_over()
	else:
		pass
