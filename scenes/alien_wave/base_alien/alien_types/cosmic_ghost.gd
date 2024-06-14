extends Node2D

# child nodes
@onready var animation_player = $AnimationPlayer

var ALIEN_PROPERTIES = {
	"primary_target": "player",
	"time_gap_between_attacks": 0.8, # in seconds
	"damage_per_attack": 8,
	"speed": 180,
	"hp_points": 100,
}

# props passed onto the base_alien to render this scene
var RENDER_PROPERTIES = {
	"scale": Vector2(0.2, 0.2),
	"body_area_radius": 175,
	"body_area_height": 520,
	"body_collision_shape_radius": 130,
	"body_collision_shape_height": 500,
	"attack_range_radius": 270,
}

# global variables
var CURRENT_ANIMATION = "" # by default

func get_render_props() -> Dictionary:
	return RENDER_PROPERTIES
	
func get_alien_props() -> Dictionary:
	return ALIEN_PROPERTIES

# animation handling
func play_move_animation(_direction: String) -> void:
	if CURRENT_ANIMATION != "move":
		animation_player.seek(0, true)  # Reset the animation to its start
		animation_player.play("move")
		CURRENT_ANIMATION = "move"
	
func play_attack_animation(_direction: String) -> void:
	animation_player.seek(0, true)  # Reset the animation to its start
	animation_player.play("attack")
	CURRENT_ANIMATION = "attack"
