extends Control

const ANIMATION_TIME_PERIOD = 1.3 # how long it takes for either fade in or fade out
const TIME_TO_READ = 1.5 # in seconds
const TIME_PRE_LINE = ANIMATION_TIME_PERIOD*2 + TIME_TO_READ
const STORY_LINES = [
	"The Earth is on the brink of collapse...",
	"Desperation led humanity to the stars...",
	"Ten brave astronauts were sent to explore new worlds...",
	"One by one, nine of the team perished...",
	"Now, only you remain...",
	"Your mission: explore Planet X...",
	"The fate of humanity rests in your hands...",
	"Planet X, teeming with alien life...",
	"Your rocket, broken...",
	"You've collected the samples...",
	"Build a 'space booster' to escape...",
	"Time is running out..."
]
var CURRENT_LINE_INDEX = 0
var ELAPSED_TIME_SINCE_LINE = 0

const BUTTON = preload("res://scenes/common_ui_comps/button/button.tscn")

# child nodes
@onready var timer = $Timer
@onready var animation_player = $AnimationPlayer
@onready var story_line = $StoryLine
var skip_button

# Called when the node enters the scene tree for the first time.
func _ready():
	story_line.text = STORY_LINES[CURRENT_LINE_INDEX]
	story_line.visible = false
	
	# placing the skip button
	_place_skip_button()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ELAPSED_TIME_SINCE_LINE += delta
	
	# displaying the lines
	_display_line(delta)
	_position_story_line()
	
	# positioning the button
	_position_skip_button()
	
	# handling inputs
	if Input.is_action_just_pressed("escape"):
		_skip_story_lines()

func _display_line(delta):
	if ELAPSED_TIME_SINCE_LINE >= TIME_PRE_LINE:
		CURRENT_LINE_INDEX += 1
		if CURRENT_LINE_INDEX < STORY_LINES.size():
			story_line.visible = false
			story_line.text = STORY_LINES[CURRENT_LINE_INDEX]
			story_line.size = Vector2(0, 0)
		else:
			_skip_story_lines()
		ELAPSED_TIME_SINCE_LINE = 0
	elif ELAPSED_TIME_SINCE_LINE >= ANIMATION_TIME_PERIOD + TIME_TO_READ:
		animation_player.play("fade_out")
	elif ELAPSED_TIME_SINCE_LINE >= ANIMATION_TIME_PERIOD:
		animation_player.play("RESET")
	else:
		animation_player.play("fade_in")
		story_line.visible = true
	
func _skip_story_lines():
	SceneManager.change_to_how_to_scene()

func _position_story_line():
	var screen_size = get_viewport().size
	var x_pos = (screen_size.x/2) - (story_line.size.x/2)
	var y_pos = (screen_size.y/2) - (story_line.size.y/2)
	story_line.position = Vector2(x_pos, y_pos)

func _position_skip_button():
	var screen_size = get_viewport().size
	var x_pos = screen_size.x - (skip_button.size.x*skip_button.scale.x) - 50
	var y_pos = screen_size.y - (skip_button.size.y*skip_button.scale.y) - 50
	skip_button.position = Vector2(x_pos, y_pos)

func _place_skip_button():
	# placing the home button
	var skip_callback = Callable(self, "_skip_story_lines")
	skip_button = BUTTON.instantiate()
	skip_button.config("SKIP", "special", skip_callback)
	skip_button.scale = Vector2(0.2, 0.2)
	add_child(skip_button)
