extends Node

var spawn_wave_timer: Timer = null
var can_spawn_a_wave: bool = false
var countdown_time: int = 3  # default value of 3 ensures aliens start spawning 3 secs after the game began
var alien_types = ["cosmic_ghost", "electro_gorgon", "nebula_goblin", "stellar_beard"]

func _ready():
	# Create a new Timer node
	spawn_wave_timer = Timer.new()
	
	# Configure the Timer node
	spawn_wave_timer.wait_time = 1.0
	spawn_wave_timer.one_shot = false
	spawn_wave_timer.autostart = true
	
	# Add the Timer node to the scene tree
	add_child(spawn_wave_timer)
	
	# Connect the timeout signal
	spawn_wave_timer.connect("timeout", _on_spawn_wave_timer_timeout)

func _on_spawn_wave_timer_timeout() -> void:
	# decrease the countdown time
	countdown_time -= 1
	
	if countdown_time <= 0:
		spawn_wave_timer.stop()
		can_spawn_a_wave = true
		countdown_time = LevelManager.get_level_props()["time_gap_between_waves"]

func set_can_spawn_a_wave_to_false() -> void:
	can_spawn_a_wave = false
	spawn_wave_timer.start()

func get_alien_types() -> Array:
	return alien_types
