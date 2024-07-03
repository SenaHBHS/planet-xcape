extends Node2D

# scenes used
const BASE_DEFENSE_SYSTEM = preload("res://scenes/defense_system/base_defense_system.tscn")

@onready var builder_box_ui = $CanvasLayer/BuilderBoxUi
@onready var pause_screen = $CanvasLayer/PauseScreen
@onready var player = $Player
@onready var din_collected_sound_player = $DinCollectedSoundPlayer
@onready var background_music_player = $BackgroundMusicPlayer
@onready var place_item_cursor = $PlaceItemCursor

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
	# defense system handling
	handle_defense_systems()
	
	# pausing handling
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

func handle_defense_systems():
	place_item_cursor.global_position = get_global_mouse_position()
	
	var selected_item = InventoryManager.get_current_item()
	var is_defense_system_enabled
	if selected_item["category"] == "defense_system":
		place_item_cursor.visible = true
		is_defense_system_enabled = true
	else:
		place_item_cursor.visible = false
		is_defense_system_enabled = false
	
	if Input.is_action_just_pressed("place_item") and is_defense_system_enabled:
		# adding a defense system
		var new_defense_system = BASE_DEFENSE_SYSTEM.instantiate()
		new_defense_system.init_defense_system(selected_item["name"])
		new_defense_system.global_position = get_global_mouse_position()
		add_child(new_defense_system)
		InventoryManager.remove_current_item()

func _on_auto_save_timer_timeout():
	GameProfilesManager.save_game_profiles()
