extends StaticBody2D

var CURRENT_ANIMATION = "idle" # by default
var ANIMATION_RENDER_PROPS = {
	"idle": {
		"scale": Vector2(1, 1),
		"position": Vector2(0, 0)
	},
	"active": {
		"scale": Vector2(0.48, 0.48),
		"position": Vector2(0, -125)
	}
}

# variables related to the e-action
var E_ACTION_SCALE = Vector2(1.8, 1.8)
var E_ACTION_POS = Vector2(45, -600)
var E_ACTION = null # initialised when the scene is instantiated!
const E_ACTION_SCENE = preload("res://scenes/common_ui_comps/e_action/e_action.tscn")

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	# setting up the default stuff!
	set_builder_box_position()
	_play_animation()
	
	# dynamically setting the position
	var viewport = get_viewport()
	viewport.size_changed.connect(set_builder_box_position)
	
	# setting up the e action node!
	E_ACTION = E_ACTION_SCENE.instantiate()
	E_ACTION.set_action_text("BUILD!")
	E_ACTION.position = E_ACTION_POS
	E_ACTION.scale = E_ACTION_SCALE
	add_child(E_ACTION)
	E_ACTION.visible = false
	
func _process(_delta):
	# if the current animation is active, the player is in the interactable region!
	if Input.is_action_just_pressed("perform_action") and CURRENT_ANIMATION == "active":
		open_builder_box()
	
	# if the game is not paused
	if not get_tree().paused:
		SignalManager.set_builder_box_opened.emit(false)
	
func open_builder_box():
	SignalManager.set_builder_box_opened.emit(true)
	get_tree().paused = true

func set_builder_box_position():
	var screen_size = get_viewport().size
	var new_x_pos = 200 # how much is shifted to the right by default
	var new_y_pos = (screen_size.y / 2) - 20
	global_position = Vector2(new_x_pos, new_y_pos)
	
func _play_animation():
	var current_anim_props = ANIMATION_RENDER_PROPS[CURRENT_ANIMATION]
	animated_sprite_2d.scale = current_anim_props["scale"]
	animated_sprite_2d.position = current_anim_props["position"]
	
	animated_sprite_2d.play(CURRENT_ANIMATION)
	animation_player.play(CURRENT_ANIMATION)

func _on_player_actionable_region_body_entered(body):
	if body.is_in_group("player") and CURRENT_ANIMATION != "active":
		CURRENT_ANIMATION = "active"
		E_ACTION.visible = true
		_play_animation()

func _on_player_actionable_region_body_exited(body):
	if body.is_in_group("player") and CURRENT_ANIMATION != "idle":
		CURRENT_ANIMATION = "idle"
		E_ACTION.visible = false
		_play_animation()
