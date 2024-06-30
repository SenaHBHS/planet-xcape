extends Node

# defining the scenes
const home_scene: PackedScene = preload("res://scenes/home_screen/home.tscn")
const select_level_scene: PackedScene = preload("res://scenes/select_level_screen/select_level.tscn")
const story_scene: PackedScene = preload("res://scenes/story/story.tscn")
const how_to_screen_scene: PackedScene = preload("res://scenes/how_to_screen/how_to_screen.tscn")
const options_scene: PackedScene = preload("res://scenes/options_screen/options.tscn")
const credits_scene: PackedScene = preload("res://scenes/credits_screen/credits.tscn")
const main_game_scene: PackedScene = preload("res://scenes/game/game.tscn")
const game_over_scene: PackedScene = preload("res://scenes/game_over_screen/game_over_screen.tscn")
const victory_scene: PackedScene = preload("res://scenes/victory_screen/victory_screen.tscn")

func change_to_home_scene():
	get_tree().change_scene_to_packed(home_scene)

func change_to_select_level_scene():
	get_tree().change_scene_to_packed(select_level_scene)

func change_to_story_scene():
	get_tree().change_scene_to_packed(story_scene)

func change_to_how_to_scene():
	get_tree().change_scene_to_packed(how_to_screen_scene)
	
func change_to_options_scene():
	get_tree().change_scene_to_packed(options_scene)

func change_to_credits_scene():
	get_tree().change_scene_to_packed(credits_scene)
	
func change_to_main_game_scene():
	get_tree().change_scene_to_packed(main_game_scene)
	
func change_to_game_over_scene():
	get_tree().change_scene_to_packed(game_over_scene)
	
func change_to_victory_scene():
	get_tree().change_scene_to_packed(victory_scene)
