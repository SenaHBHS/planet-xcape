extends Node

var spawn_wave_timer: Timer = null
var can_spawn_a_wave: bool = false
var countdown_time: int = 3  # default value of 3 ensures aliens start spawning 3 secs after the game began
var alien_types = ["cosmic_ghost", "stellar_beard", "nebula_goblin", "electro_gorgon"]

# variables used in alien_wave.gd (globablised for saving purposes)
var difficulty: float = 2.0 # to make the game progressively challenging (changes the alien speed and wait time based on this)
var alien_types_available: int = 1 # aliens are spawned upto this index from ALIEN_TYPES

func _ready():
	# Create a new Timer node
	spawn_wave_timer = Timer.new()
	
	# Configure the Timer node
	spawn_wave_timer.wait_time = 1.0
	spawn_wave_timer.one_shot = false
	spawn_wave_timer.autostart = false
	
	# Add the Timer node to the scene tree
	add_child(spawn_wave_timer)
	
	# Connect the timeout signal
	spawn_wave_timer.timeout.connect(_on_spawn_wave_timer_timeout)

func _on_spawn_wave_timer_timeout() -> void:
	# decrease the countdown time
	countdown_time -= 1
	SignalManager.alien_wave_countdown_updated.emit()
	
	if countdown_time <= 0:
		spawn_wave_timer.stop()
		can_spawn_a_wave = true
		countdown_time = LevelManager.get_level_props()["time_gap_between_waves"]

func set_can_spawn_a_wave_to_false() -> void:
	can_spawn_a_wave = false
	spawn_wave_timer.start()

func get_alien_types() -> Array:
	return alien_types

# this is used to start the timer for the first time in the main game scene
func start_timer() -> void:
	spawn_wave_timer.start()
