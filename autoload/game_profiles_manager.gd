# this file manages all the saving and loading functionality for user profiles
extends Node

# global variables
var save_path = "user://game_profiles.save"
var max_user_profile_number = 4 # there are only 4 profiles
var dummy_saved_inventory = {
	"loaded_inventory": false,
	"inventory_limit": 3,
	"available_items": [],
	"available_slots": [],
	"selected_pos": 0,
	"n_available_unlock_slot_power_ups": 6,
}
var dummy_profile = {
	"profile_name": "",
	"din_amount": 0,
	"elapsed_time": 0,
	"player_x_pos": 400,
	"player_y_pos": 250,
	"level": "rookie",
	"player_hp_points": 100, # changed later based on the level!
	"rocket_hp_points": 100,
	"equipped_weapon": "fist",
	"alien_wave_difficulty": 1,
	"alien_types_available": 1
}
var loaded_profiles = [] # this is initialised in _ready()
var current_profile_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_load_saved_game_profiles()
	
	# connecting necessary signals
	SignalManager.reset_current_profile.connect(handle_reset_current_profile)

func _create_a_new_profiles_set():
	for i in range(max_user_profile_number):
		var new_dummy_profile = dummy_profile.duplicate(true)
		new_dummy_profile["inventory"] = dummy_saved_inventory.duplicate(true)
		loaded_profiles.append(new_dummy_profile)

func load_profile(profile_index: int):
	if profile_index < max_user_profile_number:
		current_profile_index = profile_index
		var profile_data = loaded_profiles[current_profile_index]
		# loading the general settings
		DinManager.set_din_amount(int(profile_data["din_amount"]))
		ElapsedTimeManager.set_elapsed_time(profile_data["elapsed_time"])
		var player_loaded_pos = Vector2(int(profile_data["player_x_pos"]), int(profile_data["player_y_pos"]))
		GameManager.update_player_position(player_loaded_pos)
		LevelManager.set_level(profile_data["level"])
		GameManager.player_hp_points = float(profile_data["player_hp_points"])
		GameManager.rocket_hp_points = float(profile_data["rocket_hp_points"])
		WeaponManager.equipped_weapon = profile_data["equipped_weapon"]
		AlienWaveManager.difficulty = profile_data["alien_wave_difficulty"]
		AlienWaveManager.alien_types_available = profile_data["alien_types_available"]
		# loading the inventory
		InventoryManager.loaded_inventory = profile_data["inventory"]["loaded_inventory"]
		InventoryManager.inventory_limit = int(profile_data["inventory"]["inventory_limit"])
		InventoryManager.available_items = profile_data["inventory"]["available_items"]
		InventoryManager.available_slots = profile_data["inventory"]["available_slots"]
		InventoryManager.selected_pos = int(profile_data["inventory"]["selected_pos"])
		InventoryManager.n_available_unlock_slot_power_ups = int(profile_data["inventory"]["n_available_unlock_slot_power_ups"])
	else:
		push_error("Invalid Profile Index")

func set_current_profile_name(profile_name: String):
	loaded_profiles[current_profile_index]["profile_name"] = profile_name

func _save_current_profile():
	var current_profile = loaded_profiles[current_profile_index]
	# saving the general settings
	current_profile["din_amount"] = DinManager.get_din_amount()
	current_profile["elapsed_time"] = ElapsedTimeManager.elapsed_time
	current_profile["player_x_pos"] = GameManager.get_player_position().x
	current_profile["player_y_pos"] = GameManager.get_player_position().y
	current_profile["level"] = LevelManager.get_selected_level()
	current_profile["player_hp_points"] = GameManager.player_hp_points
	current_profile["rocket_hp_points"] = GameManager.rocket_hp_points
	current_profile["equipped_weapon"] = WeaponManager.equipped_weapon
	current_profile["alien_wave_difficulty"] = AlienWaveManager.difficulty
	current_profile["alien_types_available"] = AlienWaveManager.alien_types_available
	# saving the inventory
	current_profile["inventory"]["loaded_inventory"] = InventoryManager.loaded_inventory
	current_profile["inventory"]["inventory_limit"] = InventoryManager.inventory_limit
	current_profile["inventory"]["available_items"] = InventoryManager.available_items
	current_profile["inventory"]["available_slots"] = InventoryManager.available_slots
	current_profile["inventory"]["selected_pos"] = InventoryManager.selected_pos
	current_profile["inventory"]["n_available_unlock_slot_power_ups"] = InventoryManager.n_available_unlock_slot_power_ups

func _load_saved_game_profiles():
	if not FileAccess.file_exists(save_path):
		_create_a_new_profiles_set()
	else:
		var file = FileAccess.open(save_path, FileAccess.READ)
		
		var json_data = file.get_as_text()
		var json = JSON.new()
		json.parse(json_data)
		var result = json.get_data()
		file.close()
		
		if typeof(result) == TYPE_ARRAY:
			loaded_profiles = result
		else:
			_create_a_new_profiles_set()

func save_game_profiles():
	_save_current_profile()
	
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		var json_data = JSON.stringify(loaded_profiles)
		file.store_string(json_data)
		file.close()

func handle_reset_current_profile():
	var new_dummy_profile = dummy_profile.duplicate(true)
	new_dummy_profile["inventory"] = dummy_saved_inventory.duplicate(true)
	loaded_profiles[current_profile_index] = new_dummy_profile
