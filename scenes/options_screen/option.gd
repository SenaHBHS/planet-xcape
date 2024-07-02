extends Panel

# global variables
var OPTION_NAME = ""
# name displayed to the user (key is the option name used in the code)
var DISPLAYED_OPTION_NAME = {
	"sound": "Music & SFX: ",
	"selected_item_halo": "Selected Item Halo: "
}
var GAP_BETWEEN_OPTION_AND_BUTTON = 150
var BTN_Y_OFFSET = 8

# scenes used
const BUTTON = preload("res://scenes/common_ui_comps/button/button.tscn")

# child nodes
@onready var option_label = $OptionLabel
var OPTION_BTN

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(OPTION_NAME in OptionsManager.get_options_dict(), "Please select a valid option!")
	option_label.size = Vector2(0, 0)
	option_label.text = DISPLAYED_OPTION_NAME[OPTION_NAME]
	place_option_button()
	
func init_option(option_name: String):
	OPTION_NAME = option_name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position_elements()
	set_parent_size()

func _calculate_option_btn_scale():
	var label_size_y = option_label.size.y
	var scale_prop = label_size_y/OPTION_BTN.size.y
	return Vector2(scale_prop, scale_prop)

func set_parent_size():
	var button_x_size = OPTION_BTN.size.x*OPTION_BTN.scale.x
	var button_y_size = OPTION_BTN.size.y*OPTION_BTN.scale.y
	
	var x_size = option_label.size.x + button_x_size
	var y_size = max(option_label.size.y, button_y_size) + BTN_Y_OFFSET
	
	size = Vector2(x_size, y_size)

func place_option_button():
	# placing the home button
	var return_home_callback = Callable(self, "toggle_option")
	OPTION_BTN = BUTTON.instantiate()
	
	var btn_skin
	if OptionsManager.get_options_dict()[OPTION_NAME]:
		btn_skin = "on_toggled"
	else:
		btn_skin = "off_toggled"
	OPTION_BTN.config("", btn_skin, return_home_callback)
	
	OPTION_BTN.scale = Vector2(0.2, 0.2)
	
	add_child(OPTION_BTN)
	
func position_elements():
	var button_x_pos = option_label.size.x + GAP_BETWEEN_OPTION_AND_BUTTON
	
	var button_y_size = OPTION_BTN.size.y*OPTION_BTN.scale.y
	var middle_y_cor = max(option_label.size.y, button_y_size)/2
	
	var button_y_pos = middle_y_cor - (button_y_size/2) + BTN_Y_OFFSET
	var label_y_pos = middle_y_cor - (option_label.size.y/2)
	OPTION_BTN.position = Vector2(button_x_pos, button_y_pos)
	option_label.position = Vector2(0, label_y_pos)

func toggle_option():
	# used for bools
	if OptionsManager.get_options_dict()[OPTION_NAME]:
		OptionsManager.set_option(OPTION_NAME, false)
	else:
		OptionsManager.set_option(OPTION_NAME, true)
