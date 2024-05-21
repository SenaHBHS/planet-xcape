extends CharacterBody2D

# global variables
@export var SPEED: int = 500
var CURRENT_ANIMATION = "idle"
var ONE_TIME_ANIMATIONS = ["hit", "shoot"]
var ONE_TIME_ANIMATION_FINISHED = true

# child nodes
@onready var animated_sprite_2d = $AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var attack_props = handle_firing()
	var direction = handle_movement()
	handle_animations(attack_props, direction)

func handle_firing() -> Dictionary:
	var animation_name = "shoot"
	var just_attacked = null
	if Input.is_action_just_pressed("attack"):
		just_attacked = true
	else:
		just_attacked = false
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
	
	return direction

func handle_animations(attack_props: Dictionary, direction: Vector2):
	# ONE_TIME_ANIMATIONS MUST BE PLAYED TILL THE END
	if ONE_TIME_ANIMATION_FINISHED:
		if attack_props["just_attacked"]:
			animated_sprite_2d.play(attack_props["animation_name"])
			CURRENT_ANIMATION = attack_props["animation_name"]
			ONE_TIME_ANIMATION_FINISHED = false
		elif direction.x > 0:
			if CURRENT_ANIMATION != "right":
				animated_sprite_2d.flip_h = false
				animated_sprite_2d.play("run")
				CURRENT_ANIMATION = "right"
		elif direction.x < 0:
			if CURRENT_ANIMATION != "left":
				animated_sprite_2d.flip_h = true
				animated_sprite_2d.play("run")
				CURRENT_ANIMATION = "left"
		elif direction.y != 0:
			if CURRENT_ANIMATION != "vertical_motion":
				animated_sprite_2d.play("run")
				CURRENT_ANIMATION = "vertical_motion"
		else:
			if ONE_TIME_ANIMATION_FINISHED:
				animated_sprite_2d.play("idle")
				CURRENT_ANIMATION = "idle"

func _on_animation_finished():
	ONE_TIME_ANIMATION_FINISHED = true
