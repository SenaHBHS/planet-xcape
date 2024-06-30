extends Control

# global variables
var BUTTON_LABEL = null
var BUTTON_CATEGORY = null
var CALLBACK_BOUND = null

# button skins
const EXTRA_SPECIAL = preload("res://assets/ui/btns/Extra Special.png")
const SPECIAL = preload("res://assets/ui/btns/Special.png")
const NORMAL = preload("res://assets/ui/btns/Normal.png")
const REDDISH = preload("res://assets/ui/btns/Reddish.png")

# child nodes
@onready var button_node = $ButtonNode
@onready var animation_player = $AnimationPlayer
@onready var label = $Label

func sample_func():
	print("CLICKED!")

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(BUTTON_CATEGORY != null, "Please configure the button using .config()")
	# applying the button skin
	match BUTTON_CATEGORY:
		"extra_special":
			button_node.texture_normal = EXTRA_SPECIAL
		"special":
			button_node.texture_normal = SPECIAL
		"reddish":
			button_node.texture_normal = REDDISH
		_:
			# default skin
			button_node.texture_normal = NORMAL
	
	# setting the label
	label.text = BUTTON_LABEL
	
func config(btn_label: String, btn_category: String, callback_bound: Callable):
	BUTTON_LABEL = btn_label
	BUTTON_CATEGORY = btn_category
	CALLBACK_BOUND = callback_bound

func _process(_delta):
	_position_label()

func _position_label():
	var button_x_size = button_node.size.x
	var label_x_size = label.size.x
	
	var new_label_x_pos = (button_x_size/2) - (label_x_size/2)
	label.position = Vector2(new_label_x_pos, label.position.y)
	
	# to make the size accessible for the parent:
	size = button_node.size

func _on_button_pressed():
	CALLBACK_BOUND.call()

func _on_button_node_mouse_entered():
	animation_player.play("hovered")

func _on_button_node_mouse_exited():
	animation_player.play("RESET")
