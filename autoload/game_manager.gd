extends Node

# globalising the player and rocket position and hp points
var player_pos: Vector2 = Vector2(400, 250) # initial position
var rocket_pos: Vector2 = Vector2(0, 0)
# max hp points
var player_max_hp_points: float = LevelManager.get_level_props()["player_hp_points"]
var rocket_max_hp_points: float = LevelManager.get_level_props()["rocket_hp_points"]
# current hp points (can be configured later)
var player_hp_points: float = LevelManager.get_level_props()["player_hp_points"]
var rocket_hp_points: float = LevelManager.get_level_props()["rocket_hp_points"]

func _ready():
	SignalManager.level_changed.connect(_on_level_changed)

func set_game_won():
	SignalManager.reset_current_profile.emit()
	SceneManager.change_to_victory_scene()

func set_game_over():
	SignalManager.reset_current_profile.emit()
	SceneManager.change_to_game_over_scene()

func update_player_position(new_position: Vector2) -> void:
	player_pos = new_position
	
func get_player_position() -> Vector2:
	return player_pos

func get_rocket_position() -> Vector2:
	return rocket_pos

func _on_level_changed():
	# resetting hp points
	player_max_hp_points = LevelManager.get_level_props()["player_hp_points"]
	rocket_max_hp_points = LevelManager.get_level_props()["rocket_hp_points"]
	player_hp_points = LevelManager.get_level_props()["player_hp_points"]
	rocket_hp_points = LevelManager.get_level_props()["rocket_hp_points"]
