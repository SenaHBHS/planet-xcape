extends Control

const BUTTON = preload("res://scenes/common_ui_comps/button/button.tscn")

# child nodes
@onready var background = $Background
var BACK_BUTTON

# Called when the node enters the scene tree for the first time.
func _ready():
	place_back_button()
	rescale_background()
	get_viewport().size_changed.connect(rescale_background)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_position_back_button()

func rescale_background():
	var screen_size = get_viewport().size
	var width_prop = screen_size.x/background.size.x
	var height_prop = screen_size.y/background.size.y
	var scale_factor = max(width_prop, height_prop)
	background.scale = Vector2(scale_factor, scale_factor)

func place_back_button():
	# placing the home button
	var btn_callback = Callable(self, "_on_back")
	BACK_BUTTON = BUTTON.instantiate()
	BACK_BUTTON.config("BACK", "special", btn_callback)
	BACK_BUTTON.scale = Vector2(0.2, 0.2)
	add_child(BACK_BUTTON)
	
func _position_back_button():
	var screen_size = get_viewport().size
	var x_pos = screen_size.x - (BACK_BUTTON.scale.x*BACK_BUTTON.size.x) - 20
	var y_pos = 10
	BACK_BUTTON.position = Vector2(x_pos, y_pos)
	
func _on_back():
	SceneManager.change_to_home_scene()

func _on_credits_text_meta_clicked(meta):
	# `meta` is not guaranteed to be a String, so convert it to a String
	# to avoid script errors at run-time.
	OS.shell_open(str(meta))
