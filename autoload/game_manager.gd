extends Node

# game scene management
const start_screen_scene: PackedScene = preload("res://scenes/start_screen/start_screen.tscn")
const story_scene: PackedScene = preload("res://scenes/story/story.tscn")
const how_to_screen_scene: PackedScene = preload("res://scenes/how_to_screen/how_to_screen.tscn")
const main_game_scene: PackedScene = preload("res://scenes/game/game.tscn")
const game_over_scene: PackedScene = preload("res://scenes/game_over_screen/game_over_screen.tscn")

func load_start_screen():
	get_tree().change_scene_to_packed(start_screen_scene)

func load_story_scene():
	get_tree().change_scene_to_packed(story_scene)

func load_how_to_scene():
	get_tree().change_scene_to_packed(how_to_screen_scene)

func load_game_scene():
	get_tree().change_scene_to_packed(main_game_scene)

func load_game_over_scene():
	get_tree().change_scene_to_packed(game_over_scene)

# game level management
const GAME_LEVEL_PROPS = {
	"easy": {
		"duration": 10, # time limit
		"n_steps_in_each_wave": 4, # n(sub-waves) in each major wave
		"time_gap_between_waves": 10, # in seconds
		"initial_alien_count": 5,
		"alien_count_increment_for_each_step": 1, # by how much the n(aliens) should be increased in the next step
		"price_of_the_space_booster": 400,
		"boss_wave_for_each_n_waves": 2,
	},
	"medium": {
		"duration": 10, # time limit
		"n_steps_in_each_wave": 4, # n(sub-waves) in each major wave
		"time_gap_between_waves": 10, # in seconds
		"initial_alien_count": 5,
		"alien_count_increment_for_each_step": 1, # by how much the n(aliens) should be increased in the next step
		"price_of_the_space_booster": 400,
		"boss_wave_for_each_n_waves": 2,
	},
	"hard": {
		"duration": 10, # time limit
		"n_steps_in_each_wave": 4, # n(sub-waves) in each major wave
		"time_gap_between_waves": 10, # in seconds
		"initial_alien_count": 5,
		"alien_count_increment_for_each_step": 1, # by how much the n(aliens) should be increased in the next step
		"price_of_the_space_booster": 400,
		"boss_wave_for_each_n_waves": 2,
	}
}

# globalising the player position
var PLAYER_POS = Vector2(0, 0)
var ROCKET_POS = Vector2(100, 100)

func update_player_position(new_position: Vector2) -> void:
	PLAYER_POS = new_position
	
func get_player_position() -> Vector2:
	return PLAYER_POS

func get_rocket_position() -> Vector2:
	return ROCKET_POS
