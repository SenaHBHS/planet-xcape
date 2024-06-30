extends Control

# rendering related global variables
var Y_GAP_BETWEEN_ELEMENTS = -50

const BUTTON = preload("res://scenes/common_ui_comps/button/button.tscn")

# child nodes
@onready var background = $Background
@onready var title_logo = $TitleLogo

var TO_RENDER_ELEMENTS = null
var BUTTONS = [
	{
		"label": "START GAME",
		"category": "extra_special",
		"callback_bound": "_on_start_game"
	},
	{
		"label": "OPTIONS",
		"category": "normal",
		"callback_bound": "_on_options"
	},
	{
		"label": "CREDITS",
		"category": "normal",
		"callback_bound": "_on_credits"
	},
	{
		"label": "QUIT",
		"category": "reddish",
		"callback_bound": "_on_quit"
	},
]

# Called when the node enters the scene tree for the first time.
func _ready():
	TO_RENDER_ELEMENTS = [title_logo]
	place_buttons()
	rescale_background()
	get_viewport().size_changed.connect(rescale_background)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position_elements()
	
func rescale_background():
	var screen_size = get_viewport().size
	var width_prop = screen_size.x/background.size.x
	var height_prop = screen_size.y/background.size.y
	var scale_factor = max(width_prop, height_prop)
	background.scale = Vector2(scale_factor, scale_factor)

func place_buttons():
	for button in BUTTONS:
		place_button(button["label"], button["category"], button["callback_bound"])

func position_elements():
	# an ordered list (assumes that the last element is the home button)
	var screen_size = get_viewport().size
	var total_height = _get_total_element_height(TO_RENDER_ELEMENTS)
	
	var current_y_pos = (screen_size.y/2) - (total_height/2)
	for element_i in range(TO_RENDER_ELEMENTS.size()):
		var current_element = TO_RENDER_ELEMENTS[element_i]
		var x_pos = _get_x_pos(current_element.size.x, current_element.scale.x, screen_size)
		current_element.position = Vector2(x_pos, current_y_pos)
		current_y_pos += Y_GAP_BETWEEN_ELEMENTS + (current_element.size.y*current_element.scale.y)

func place_button(btn_label: String, btn_category: String, callback_name: String):
	# placing the home button
	var btn_callback = Callable(self, callback_name)
	var button = BUTTON.instantiate()
	button.config(btn_label, btn_category, btn_callback)
	button.scale = Vector2(0.4, 0.4)
	TO_RENDER_ELEMENTS.append(button)
	add_child(button)

func _get_total_element_height(elements_list):
	var _total_height = 0
	for element in elements_list:
		_total_height += element.size.y * element.scale.y
	
	# adding the gaps
	_total_height += (Y_GAP_BETWEEN_ELEMENTS * (elements_list.size() - 1))
	return _total_height
	
func _get_x_pos(item_size_x, item_scale_x, screen_size):
	var x_pos = (screen_size.x/2) - (item_size_x*item_scale_x*0.5)
	return x_pos

func _on_start_game():
	SceneManager.change_to_select_level_scene()
	
func _on_options():
	print("OPTIONS OPENED")

func _on_credits():
	SceneManager.change_to_credits_scene()
	
func _on_quit():
	get_tree().quit()
