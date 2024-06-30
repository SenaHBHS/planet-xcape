extends Node

# weapon properties
const weapon_props = {
	"beam_blaster": {
		"damage_per_hit": 4,
		"hp_points": 25, # n_times_it can be fired!
		"load_time": 0.8 # in seconds
	},
	"plasma_streamer": {
		"damage_per_hit": 6,
		"hp_points": 30, # n_times_it can be fired!
		"load_time": 0.6 # in seconds
	},
	"pulse_pistol": {
		"damage_per_hit": 2,
		"hp_points": 15, # n_times_it can be fired!
		"load_time": 0.9 # in seconds
	}
}

var equipped_weapon = "fist" # default (user can choose others later)

func _ready():
	SignalManager.player_fired.connect(on_player_fired)
	
func on_player_fired():
	var selected_weapon_inventory_obj = InventoryManager.get_current_item()
	selected_weapon_inventory_obj["hp_points"] -= 1
	
	# dealing with the weapon's lifetime
	if selected_weapon_inventory_obj["hp_points"] <= 0:
		InventoryManager.remove_current_item()

func change_equipped_weapon(new_equipped_weapon: String) -> void:
	# this even adds extra properties for the currently selected item!
	equipped_weapon = new_equipped_weapon

func get_props_for_weapon(weapon_name) -> Dictionary:
	return weapon_props[weapon_name]
	
