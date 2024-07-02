extends Control

# global variables
var Y_GAP_BETWEEN_ELEMENTS = 70
var TO_RENDER_ELEMENTS = null

# scenes used
const OPTION = preload("res://scenes/options_screen/option.tscn")
const BUTTON = preload("res://scenes/common_ui_comps/button/button.tscn")

# child nodes
@onready var options_title_label = $OptionsTitleLabel
@onready var background = $Background
@onready var options_container = $OptionsContainer
var BACK_BUTTON

# Called when the node enters the scene tree for the first time.
func _ready():
	place_back_button()
	set_up_options()
	rescale_background()
	
	# connecting to necessary signals
	get_viewport().size_changed.connect(rescale_background)
	SignalManager.options_chagned.connect(set_up_options)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	position_elements()

func rescale_background():
	var screen_size = get_viewport().size
	var width_prop = screen_size.x/background.size.x
	var height_prop = screen_size.y/background.size.y
	var scale_factor = max(width_prop, height_prop)
	background.scale = Vector2(scale_factor, scale_factor)

func set_up_options():
	TO_RENDER_ELEMENTS = [options_title_label]
	
	# removing all the existing options from the container
	for child in options_container.get_children():
		options_container.remove_child(child)
		
	for option_name in OptionsManager.get_options_dict().keys():
		var new_option = OPTION.instantiate()
		new_option.init_option(option_name)
		options_container.add_child(new_option)
		TO_RENDER_ELEMENTS.append(new_option)

func position_elements():
	# positioning the back button first
	_position_back_button()
	
	# an ordered list (assumes that the last element is the home button)
	var screen_size = get_viewport().size
	var total_height = _get_total_element_height(TO_RENDER_ELEMENTS)
	
	var current_y_pos = (screen_size.y/2) - (total_height/2)
	for element_i in range(TO_RENDER_ELEMENTS.size()):
		var current_element = TO_RENDER_ELEMENTS[element_i]
		var x_pos = _get_x_pos(current_element.size.x, current_element.scale.x, screen_size)
		current_element.position = Vector2(x_pos, current_y_pos)
		current_y_pos += Y_GAP_BETWEEN_ELEMENTS + (current_element.size.y*current_element.scale.y)

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
