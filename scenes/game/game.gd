extends Node2D

@onready var builder_box_ui = $CanvasLayer/BuilderBoxUi
@onready var pause_screen = $CanvasLayer/PauseScreen
@onready var player = $Player
@onready var din_collected_sound_player = $DinCollectedSoundPlayer
@onready var background_music_player = $BackgroundMusicPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().paused:
		pause_screen.visible = true
		
	# positioning elements
	player.global_position = GameManager.get_player_position()
	pause_screen.position_elements()
	
	# playing background music
	play_background_music()
	
	# connecting signals
	SignalManager.set_builder_box_opened.connect(handle_builder_box)
	SignalManager.din_collected.connect(play_din_collected_sound)
	SignalManager.options_chagned.connect(play_background_music)
	
	# starting the timers to spawn aliens and keep track of elapsed time
	AlienWaveManager.start_timer()
	ElapsedTimeManager.start_timer()
	
func _process(_delta):
	if Input.is_action_just_pressed("escape"):
		pause_screen.visible = true
		get_tree().paused = true
	else:
		if pause_screen.visible:
			pause_screen.visible = false

func handle_builder_box(is_open: bool):
	if is_open:
		builder_box_ui.BUILDER_BOX_IS_OPEN = true
		builder_box_ui.visible = true
	else:
		builder_box_ui.BUILDER_BOX_IS_OPEN = false
		builder_box_ui.visible = false

func play_din_collected_sound():
	if OptionsManager.get_options_dict()["sound"]:
		din_collected_sound_player.play()

func play_background_music():
	if OptionsManager.get_options_dict()["sound"]:
		background_music_player.play()
	else:
		background_music_player.stop()
