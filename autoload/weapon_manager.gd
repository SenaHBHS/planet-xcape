extends Node

# weapon properties
const handheld_weapon_props = {
	"beam_blaster": {
		"damage_per_hit": 10,
		"hp_point": 100
	}
}

# weapons player has bought
const weapons_available = [{
	"weapon_type": "default",
	"weapon_name": "fist"
}, {
	# a dummy weapon
	"weapon_type": "handheld",
	"weapon_name": "beam_blaster",
	"damage_caused_so_far": 2,
}]

var equipped_weapon = "fist" # default (user can choose others later)

func change_equipped_weapon(new_equipped_weapon: String) -> void:
	equipped_weapon = new_equipped_weapon

func add_new_available_weapon(type: String, name: String) -> void:
	weapons_available.append({
		"weapon_type": type,
		"weapon_name": name,
		"damage_caused_so_far": 0
	})
