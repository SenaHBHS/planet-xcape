extends Node

# weapon properties
const weapon_props = {
	"beam_blaster": {
		"damage_per_hit": 10,
		"hp_point": 100 # n_times_it can be fired!
	},
	"plasma_streamer": {
		"damage_per_hit": 10,
		"hp_point": 100 # n_times_it can be fired!
	},
}

var equipped_weapon = "fist" # default (user can choose others later)

func change_equipped_weapon(new_equipped_weapon: String) -> void:
	# this even adds extra properties for the currently selected item!
	equipped_weapon = new_equipped_weapon

func get_props_for_weapon(weapon_name) -> Dictionary:
	return weapon_props[weapon_name]
