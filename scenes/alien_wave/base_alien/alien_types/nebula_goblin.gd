extends Node2D

# props passed onto the base_alien to render this scene
var RENDER_PROPERTIES = {
	"scale": Vector2(1, 1),
	"player_body_area_radius": 260,
	"player_body_area_height": 538,
	"player_attack_range_radius": 690
}

func get_render_props() -> Dictionary:
	return RENDER_PROPERTIES

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
