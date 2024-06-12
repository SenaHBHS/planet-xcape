extends Node2D

var ALIEN_PROPERTIES = {
	"primary_target": "player",
	"time_gap_between_attacks": 10, # in seconds
	"damage_per_attack": 10,
	"speed": 150
}

# props passed onto the base_alien to render this scene
var RENDER_PROPERTIES = {
	"scale": Vector2(0.2, 0.2),
	"player_body_area_radius": 230,
	"player_body_area_height": 538,
	"player_attack_range_radius": 250,
}

func get_render_props() -> Dictionary:
	return RENDER_PROPERTIES
	
func get_alien_props() -> Dictionary:
	return ALIEN_PROPERTIES

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
