extends Node2D

# child nodes
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer

var ALIEN_PROPERTIES = {
	"primary_target": "player",
	"time_gap_between_attacks": 0.4, # in seconds
	"damage_per_attack": 4,
	"speed": 160,
	"hp_points": 5,
}

# props passed onto the base_alien to render this scene
var RENDER_PROPERTIES = {
	"scale": Vector2(0.2, 0.2),
	"body_area_radius": 190,
	"body_area_height": 495,
	"body_collision_shape_radius": 130,
	"body_collision_shape_height": 460,
	"attack_range_radius": 240,
}

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
	
	animation_player.play("move")
	animated_sprite_2d.play("idle")
	
func play_attack_animation(direction: String) -> void:
	if direction == "right":
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
	
	animation_player.play("RESET")
	animated_sprite_2d.play("attack")
