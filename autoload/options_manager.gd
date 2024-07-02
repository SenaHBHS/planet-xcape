extends Node

var options_dict = {
	"sound": true,
	"selected_item_halo": true
}
var options_save_path = "user://options.save"

func _ready():
	# loading saved options
	_load_user_options()

func get_options_dict() -> Dictionary:
	return options_dict

func set_option(option_name: String, state: bool) -> void:
	options_dict[option_name] = state
	_save_user_options()
	SignalManager.options_chagned.emit()

# the following are saving and loading functions
func _save_user_options() -> void:
	var file = FileAccess.open_encrypted_with_pass(options_save_path, FileAccess.WRITE, "TOP SECRET PLANET X")
	if file:
		var json_data = JSON.stringify(options_dict)
		file.store_string(json_data)
		file.close()

func _load_user_options() -> void:
	if not FileAccess.file_exists(options_save_path):
		pass # using the default values
	else:
		var file = FileAccess.open_encrypted_with_pass(options_save_path, FileAccess.READ, "TOP SECRET PLANET X")
		
		var json_data = file.get_as_text()
		var json = JSON.new()
		json.parse(json_data)
		var result = json.get_data()
		file.close()
		
		if typeof(result) == TYPE_DICTIONARY:
			options_dict = result
		else:
			pass # using the default values
