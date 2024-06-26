extends Node2D

# child nodes
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer

var ALIEN_PROPERTIES = {
	"primary_target": "player",
	"time_gap_between_attacks": 0.6, # in seconds
	"damage_per_attack": 5,
	"speed": 160,
	"hp_points": 8,
	"din_value": 16
}

# props passed onto the base_alien to render this scene
var RENDER_PROPERTIES = {
	"scale": Vector2(0.2, 0.2),
	"body_area_radius": 190,
	"body_area_height": 528,
	"body_collision_shape_radius": 180,
	"body_collision_shape_height": 440,
	"attack_range_radius": 750,
}

# since there are differences in dimensions of sprites,
# when attacking the electro gorgon must be offset
var X_OFFSET_WHEN_ATTACKING = 80
var Y_OFFSET_WHEN_ATTACKING = -10
var SCALE_WHEN_ATTACKING = Vector2(1.2, 1.2)

func get_render_props() -> Dictionary:
	return RENDER_PROPERTIES
	
func get_alien_props() -> Dictionary:
	return ALIEN_PROPERTIES

# animation handling
func play_move_animation(direction: String) -> void:
	if direction == "right":
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
	
	# resetting the position
	animated_sprite_2d.position = Vector2(0, 0)
	# resetting the scale
	scale = Vector2(1, 1)
	
	animation_player.play("move")
	animated_sprite_2d.play("idle")
	
func play_attack_animation(direction: String) -> void:
	if direction == "right":
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.position = Vector2(X_OFFSET_WHEN_ATTACKING, Y_OFFSET_WHEN_ATTACKING)
	else:
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.position = Vector2(-X_OFFSET_WHEN_ATTACKING, Y_OFFSET_WHEN_ATTACKING)
	
	scale = SCALE_WHEN_ATTACKING
	
	animation_player.play("RESET")
	animated_sprite_2d.play("attack")
