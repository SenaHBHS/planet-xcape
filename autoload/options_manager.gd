extends Node

var options_dict = {
	"sound": false,
	"selected_item_halo": true
}

func get_options_dict() -> Dictionary:
	return options_dict

func set_option(option_name: String, state: bool) -> void:
	SignalManager.options_chagned.emit()
	options_dict[option_name] = state
