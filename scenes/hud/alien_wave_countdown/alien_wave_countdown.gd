extends Panel

var possible_x_range = Vector2(717, 848)
var y_pos = 231

@onready var countdown_label = $CountdownLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	update_countdown()
	SignalManager.alien_wave_countdown_updated.connect(update_countdown)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible != !AlienWaveManager.can_spawn_a_wave:
		visible = !AlienWaveManager.can_spawn_a_wave
		set_label_to_loading()
	
func position_label():
	var x_pos
	var delta_possib_x_range = possible_x_range.y - possible_x_range.x
	if countdown_label.size.x < (delta_possib_x_range):
		x_pos = (possible_x_range.x + possible_x_range.y)/2 - countdown_label.size.x/2
	else:
		x_pos = possible_x_range.x
	
	countdown_label.position = Vector2(x_pos, y_pos)

func update_countdown():
	countdown_label.text = str(AlienWaveManager.countdown_time)
	position_label()

func set_label_to_loading():
	countdown_label.text = "..."
	position_label()
