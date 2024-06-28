extends StaticBody2D

var OBJECT_NAME = "rocket" # accessed in the alien scene to emit approriate signals!

# variables related to the e-action
var E_ACTION_POS = Vector2(30, -300)
var E_ACTION = null # initialised when the scene is instantiated!
const E_ACTION_SCENE = preload("res://scenes/common_ui_comps/e_action/e_action.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_rocket_position()
	GameManager.rocket_hp_points = LevelManager.get_level_props()["rocket_hp_points"]
	
	# connecting necessary signals
	SignalManager.rocket_was_hit.connect(handle_rocket_was_hit)
	var viewport = get_viewport()
	viewport.size_changed.connect(set_rocket_position)
	
	# setting up the e action node!
	E_ACTION = E_ACTION_SCENE.instantiate()
	E_ACTION.set_action_text("LAUNCH!")
	E_ACTION.position = E_ACTION_POS
	add_child(E_ACTION)
	E_ACTION.visible = false

func _process(_delta):
	var space_booster_is_available = GameManager.get_space_booster_availability()
	var player_is_in_region = E_ACTION.visible # this implies whether the player is in the interactable region
	if Input.is_action_just_pressed("perform_action"):
		if player_is_in_region and space_booster_is_available:
			GameManager.set_game_won()
		else:
			pass
	
func set_rocket_position():
	var screen_size = get_viewport().size
	var new_rocket_pos = screen_size / 2
	new_rocket_pos.y -= 50 # moving the rocket up along the y-axis slightly
	GameManager.rocket_pos = new_rocket_pos
	global_position = new_rocket_pos

func handle_rocket_was_hit(damage_points):
	GameManager.rocket_hp_points -= damage_points
	SignalManager.rocket_hp_points_updated.emit()
	
	if GameManager.rocket_hp_points <= 0:
		GameManager.set_game_over()
	else:
		pass

func _on_actionable_region_body_entered(body):
	var player_has_space_booster = GameManager.get_space_booster_availability()
	if body.is_in_group("player") and player_has_space_booster:
		E_ACTION.visible = true

func _on_actionable_region_body_exited(body):
	if body.is_in_group("player"):
		E_ACTION.visible = false
