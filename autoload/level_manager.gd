extends Node

# game level management
var level = "rookie"

const game_level_props = {
	"rookie": {
		"player_hp_points": 50,
		"rocket_hp_points": 250,
		"n_subwaves": 2, # n(sub-waves) in each major wave
		"n_boss_subwaves": 1,
		"time_gap_between_waves": 10, # in seconds
		"time_gap_between_subwaves": 5, # in seconds
		"lower_n_alien_bound": 2,
		"space_booster_price": 400,
		"boss_wave_frequency": 2, # a boss wave per n(waves)
		"difficutly_increase_per_wave_spawned": 0.02
	},
	"veteran": {
		"player_hp_points": 100,
		"rocket_hp_points": 250,
		"n_subwaves": 4, # n(sub-waves) in each major wave
		"n_boss_subwaves": 1,
		"time_gap_between_waves": 5, # in seconds
		"time_gap_between_subwaves": 2, # in seconds
		"lower_n_alien_bound": 4,
		"space_booster_price": 500,
		"boss_wave_frequency": 3, # a boss wave per n(waves)
		"difficutly_increase_per_wave_spawned": 0.02
	},
	"master": {
		"player_hp_points": 100,
		"rocket_hp_points": 250,
		"n_subwaves": 4, # n(sub-waves) in each major wave
		"n_boss_subwaves": 1,
		"time_gap_between_waves": 5, # in seconds
		"time_gap_between_subwaves": 2, # in seconds
		"lower_n_alien_bound": 5,
		"space_booster_price": 600,
		"boss_wave_frequency": 4, # a boss wave per n(waves)
		"difficutly_increase_per_wave_spawned": 0.02
	}
}

func set_level(selected_level: String) -> void:
	level = selected_level
	
func get_selected_level() -> String:
	return level

func get_level_props() -> Dictionary:
	assert(level != "", "Please set a level using set_level(level)")
	return game_level_props[level]
