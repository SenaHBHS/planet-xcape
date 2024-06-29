extends Control

var HOME_BUTTON = null
const BUTTON = preload("res://scenes/common_ui_comps/button/button.tscn")

# rendering related global variables
var Y_GAP_BETWEEN_ELEMENTS = 20
var BTN_Y_OFFSET = 50

# chlid nodes
@onready var player_face = $PlayerFace
@onready var game_over_label = $GameOverLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	place_home_button()
	
func _process(_delta):
	position_elements()
	
func position_elements():
	# an ordered list (assumes that the last element is the home button)
	var to_render_elements = [game_over_label, player_face, HOME_BUTTON]
	var screen_size = get_viewport().size
	var total_height = _get_total_element_height(to_render_elements)
	
	var current_y_pos = (screen_size.y/2) - (total_height/2)
	for element_i in range(to_render_elements.size()):
		var current_element = to_render_elements[element_i]
		var x_pos = _get_x_pos(current_element.size.x, current_element.scale.x, screen_size)
		if element_i == (to_render_elements.size() - 1):
			# the last element is always the button
			current_y_pos += BTN_Y_OFFSET
		current_element.position = Vector2(x_pos, current_y_pos)
		current_y_pos += Y_GAP_BETWEEN_ELEMENTS + (current_element.size.y*current_element.scale.y)

func place_home_button():
	# placing the home button
	var return_home_callback = Callable(self, "_return_home")
	HOME_BUTTON = BUTTON.instantiate()
	HOME_BUTTON.config("BACK HOME", "special", return_home_callback)
	HOME_BUTTON.scale = Vector2(0.3, 0.3)
	add_child(HOME_BUTTON)

func _return_home():
	SceneManager.change_to_home_scene()

func _get_total_element_height(elements_list):
	var _total_height = 0
	for element in elements_list:
		_total_height += element.size.y * element.scale.y
	
	# adding the gaps
	_total_height += (Y_GAP_BETWEEN_ELEMENTS * (elements_list.size() - 1)) + BTN_Y_OFFSET
	return _total_height
	
func _get_x_pos(item_size_x, item_scale_x, screen_size):
	var x_pos = (screen_size.x/2) - (item_size_x*item_scale_x*0.5)
	return x_pos
