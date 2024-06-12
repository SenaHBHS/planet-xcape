extends Node2D

# child nodes
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer

var ALIEN_PROPERTIES = {
	"primary_target": "player",
	"time_gap_between_attacks": 10, # in seconds
	"damage_per_attack": 10,
	"speed": 150
}

# props passed onto the base_alien to render this scene
var RENDER_PROPERTIES = {
	"scale": Vector2(0.2, 0.2),
	"player_body_area_radius": 240,
	"player_body_area_height": 538,
	"player_attack_range_radius": 260,
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
	
	animation_player.play("fly")
	animated_sprite_2d.play("fly")
	
func play_attack_animation(direction: String) -> void:
	if direction == "right":
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
	
	animation_player.play("RESET")
	animated_sprite_2d.play("attack")
