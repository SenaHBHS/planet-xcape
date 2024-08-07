extends Node

# game level management
var level = "rookie"

const game_level_props = {
	"rookie": {
		"player_hp_points": 180,
		"rocket_hp_points": 320,
		"n_subwaves": 2, # n(sub-waves) in each major wave
		"n_boss_subwaves": 1,
		"time_gap_between_waves": 10, # in seconds
		"time_gap_between_subwaves": 3, # in seconds
		"lower_n_alien_bound": 1,
		"space_booster_price": 400,
		"boss_wave_frequency": 4, # a boss wave per n(waves)
		"difficutly_increase_per_wave_spawned": 0.02,
		"n_stars_to_spawn": 1 # in the victory screen
	},
	"veteran": {
		"player_hp_points": 200,
		"rocket_hp_points": 380,
		"n_subwaves": 2, # n(sub-waves) in each major wave
		"n_boss_subwaves": 1,
		"time_gap_between_waves": 13, # in seconds
		"time_gap_between_subwaves": 2, # in seconds
		"lower_n_alien_bound": 2,
		"space_booster_price": 525,
		"boss_wave_frequency": 3, # a boss wave per n(waves)
		"difficutly_increase_per_wave_spawned": 0.04,
		"n_stars_to_spawn": 2 # in the victory screen
	},
	"master": {
		"player_hp_points": 280,
		"rocket_hp_points": 450,
		"n_subwaves": 3, # n(sub-waves) in each major wave
		"n_boss_subwaves": 2,
		"time_gap_between_waves": 15, # in seconds
		"time_gap_between_subwaves": 2, # in seconds
		"lower_n_alien_bound": 4,
		"space_booster_price": 650,
		"boss_wave_frequency": 2, # a boss wave per n(waves)
		"difficutly_increase_per_wave_spawned": 0.08,
		"n_stars_to_spawn": 3 # in the victory screen
	}
}

func set_level(selected_level: String) -> void:
	level = selected_level
	SignalManager.level_changed.emit()
	
func get_selected_level() -> String:
	return level

func get_level_props() -> Dictionary:
	assert(level != "", "Please set a level using set_level(level)")
	return game_level_props[level]
