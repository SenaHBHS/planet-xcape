extends Control

# rendering related global variables
var Y_GAP_BETWEEN_ELEMENTS = -40

const BUTTON = preload("res://scenes/common_ui_comps/button/button.tscn")

# child nodes
@onready var select_profile_label = $SelectProfileLabel

var TO_RENDER_ELEMENTS = null
var BUTTONS = []

# Called when the node enters the scene tree for the first time.
func _ready():
	set_up_buttons()
	TO_RENDER_ELEMENTS = [select_profile_label]
	place_buttons()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	position_elements()

# fills the BUTTONS list based on the GameProfiles Loaded!
func set_up_buttons():
	for profile_i in range(GameProfilesManager.loaded_profiles.size()):
		var profile_data = GameProfilesManager.loaded_profiles[profile_i]
		if profile_data["profile_name"] != "":
			# meaning, there's a saved version
			BUTTONS.append({
				"label": profile_data["profile_name"],
				"category": "normal",
				"callback_bound": "_on_continue_%d_profile" % profile_i
			})
		else:
			BUTTONS.append({
				"label": "New Game",
				"category": "blank",
				"callback_bound": "_on_new_%d_profile" % profile_i
			})

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

func _new_game():
	SceneManager.change_to_name_profile_scene()

func _continue_game(selected_profile_index: int):
	GameProfilesManager.load_profile(selected_profile_index)
	SceneManager.change_to_main_game_scene()

# funcs for each button
func _on_new_0_profile():
	GameProfilesManager.load_profile(0)
	_new_game()
func _on_new_1_profile():
	GameProfilesManager.load_profile(1)
	_new_game()
func _on_new_2_profile():
	GameProfilesManager.load_profile(2)
	_new_game()
func _on_new_3_profile():
	GameProfilesManager.load_profile(3)
	_new_game()

func _on_continue_0_profile():
	_continue_game(0)
func _on_continue_1_profile():
	_continue_game(1)
func _on_continue_2_profile():
	_continue_game(2)
func _on_continue_3_profile():
	_continue_game(3)
