extends Node

# game level management
var level = "rookie"

const game_level_props = {
	"rookie": {
		"n_subwaves": 3, # n(sub-waves) in each major wave
		"time_gap_between_waves": 5, # in seconds
		"time_gap_between_subwaves": 2, # in seconds
		"lower_n_alien_bound": 3,
		"price_of_the_space_booster": 400,
		"boss_wave_frequency": 2, # a boss wave per n(waves)
	},
	"veteran": {
		"n_subwaves": 4, # n(sub-waves) in each major wave
		"time_gap_between_waves": 5, # in seconds
		"time_gap_between_subwaves": 2, # in seconds
		"lower_n_alien_bound": 4,
		"price_of_the_space_booster": 500,
		"boss_wave_frequency": 3, # a boss wave per n(waves)
	},
	"master": {
		"n_steps_in_each_wave": 4, # n(sub-waves) in each major wave
		"time_gap_between_waves": 5, # in seconds
		"time_gap_between_subwaves": 2, # in seconds
		"lower_n_alien_bound": 5,
		"price_of_the_space_booster": 600,
		"boss_wave_frequency": 4, # a boss wave per n(waves)
	}
}

func _deploy_funcs_on_selected_level() -> void:
	game_level_props[level]

func set_level(selected_level: String) -> void:
	level = selected_level
	_deploy_funcs_on_selected_level()
	
func get_selected_level() -> String:
	return level

func get_level_props() -> Dictionary:
	assert(level != "", "Please set a level using set_level(level)")
	return game_level_props[level]
