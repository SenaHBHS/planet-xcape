extends StaticBody2D

var HP_POINTS = null # configured later 

# Called when the node enters the scene tree for the first time.
func _ready():
	HP_POINTS = LevelManager.get_level_props()["rocket_hp_points"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
