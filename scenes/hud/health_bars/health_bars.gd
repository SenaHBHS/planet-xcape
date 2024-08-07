extends Panel

# global variables
var MAX_PLAYER_HP
var MAX_ROCKET_HP
var HEALTH_BAR_VISIBLE_RANGE = Vector2(25, 100)

# health bar nodes
@onready var player_health_bar = $PlayerHealthBar
@onready var rocket_health_bar = $RocketHealthBar

# Called when the node enters the scene tree for the first time.
func _ready():
	MAX_PLAYER_HP = GameManager.player_max_hp_points
	MAX_ROCKET_HP = GameManager.rocket_max_hp_points
	
	# setting initial values
	player_health_bar.value = GameManager.player_hp_points
	rocket_health_bar.value = GameManager.rocket_hp_points
	handle_player_hp_points_update()
	handle_rocket_hp_points_update()
	
	SignalManager.player_hp_points_updated.connect(handle_player_hp_points_update)
	SignalManager.rocket_hp_points_updated.connect(handle_rocket_hp_points_update)
	
func _get_new_health_bar_value(current_hp_value, initial_hp_points):
	var hp_proportion = current_hp_value/initial_hp_points
	var health_value =  HEALTH_BAR_VISIBLE_RANGE.x + (HEALTH_BAR_VISIBLE_RANGE.y - HEALTH_BAR_VISIBLE_RANGE.x) * hp_proportion
	return health_value
	
func handle_player_hp_points_update():
	var current_hp = GameManager.player_hp_points
	player_health_bar.value = _get_new_health_bar_value(current_hp, MAX_PLAYER_HP)

func handle_rocket_hp_points_update():
	var current_hp = GameManager.rocket_hp_points
	rocket_health_bar.value = _get_new_health_bar_value(current_hp, MAX_PLAYER_HP)
