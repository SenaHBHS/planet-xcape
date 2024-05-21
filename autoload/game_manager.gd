extends Node

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
