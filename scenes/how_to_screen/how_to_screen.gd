extends Control

var DONE_BUTTON = null
const BUTTON = preload("res://scenes/common_ui_comps/button/button.tscn")

# child nodes
@onready var how_to_info = $HowToInfo

# Called when the node enters the scene tree for the first time.
func _ready():
	# placing a done button
	place_done_button()
	
	# dealing with the how_to_info size
	_rescale_how_to_info()
	get_viewport().size_changed.connect(_rescale_how_to_info)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	_position_how_to_info()
	_position_done_button()

func _rescale_how_to_info():
	var screen_size = get_viewport().size
	var width_prop = screen_size.x/how_to_info.size.x
	var height_prop = screen_size.y/how_to_info.size.y
	var scale_factor = min(width_prop, height_prop) * 0.95 # 95% of the scale's used to get a sufficien margin
	how_to_info.scale = Vector2(scale_factor, scale_factor)

func _position_how_to_info():
	var screen_size = get_viewport().size
	var x_pos = (screen_size.x/2) - ((how_to_info.size.x*how_to_info.scale.x)/2)
	var y_pos = (screen_size.y/2) - ((how_to_info.size.y*how_to_info.scale.y)/2)
	how_to_info.position = Vector2(x_pos, y_pos)

func place_done_button():
	var btn_callback = Callable(self, "_on_done")
	DONE_BUTTON = BUTTON.instantiate()
	DONE_BUTTON.config("DONE", "extra_special", btn_callback)
	DONE_BUTTON.scale = Vector2(0.18, 0.18)
	add_child(DONE_BUTTON)
	
func _on_done():
	SceneManager.change_to_main_game_scene()

func _position_done_button():
	var screen_size = get_viewport().size
	var x_pos = screen_size.x - (DONE_BUTTON.size.x*DONE_BUTTON.scale.x) - 30
	var y_pos = 30
	DONE_BUTTON.position = Vector2(x_pos, y_pos)
