extends Node

var elapsed_time: int = 0 # in seconds
var elapsed_timer: Timer = null

# Called when the node enters the scene tree for the first time.
func _ready():
	elapsed_timer = Timer.new()
	
	# configuring the timer
	elapsed_timer.wait_time = 1.0
	elapsed_timer.one_shot = true
	elapsed_timer.autostart = true
	
	add_child(elapsed_timer)
	elapsed_timer.timeout.connect(_on_elapsed_timer_timeout)

func _on_elapsed_timer_timeout():
	elapsed_time += 1
	SignalManager.one_second_elapsed.emit()
	elapsed_timer.start()
	
func get_elapsed_time():
	var n_minutes = int(elapsed_time / 60)
	var n_seconds = elapsed_time % 60
	return [n_minutes, n_seconds]
	
func stop_elapsed_timer():
	elapsed_timer.stop()
	
# for loading and resetting,
func set_elapsed_time(new_elapsed_time: int):
	elapsed_time = new_elapsed_time
