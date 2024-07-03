extends Control

const BUTTON = preload("res://scenes/common_ui_comps/button/button.tscn")

# child nodes
var NEXT_BUTTON
@onready var line_edit = $LineEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	place_next_button()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	position_next_button()

func place_next_button():
	# placing the home button
	var btn_callback = Callable(self, "_on_next")
	NEXT_BUTTON = BUTTON.instantiate()
	NEXT_BUTTON.config("NEXT", "special", btn_callback)
	NEXT_BUTTON.scale = Vector2(0.3, 0.3)
	add_child(NEXT_BUTTON)

func position_next_button():
	var screen_size = get_viewport().size
	var x_pos = screen_size.x - (NEXT_BUTTON.size.x * NEXT_BUTTON.scale.x) - 50
	var y_pos = screen_size.y - (NEXT_BUTTON.size.y * NEXT_BUTTON.scale.y) - 50
	NEXT_BUTTON.position = Vector2(x_pos, y_pos)

func set_profile_name(input_text: String):
	if input_text != "":
		GameProfilesManager.set_current_profile_name(input_text)
		SceneManager.change_to_select_level_scene()

func _on_next():
	set_profile_name(line_edit.text)

func _on_line_edit_text_submitted(new_text):
	set_profile_name(new_text)
