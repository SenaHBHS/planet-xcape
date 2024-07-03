extends Node2D

var SYSTEM_NAME = ""
var SYSTEM_TYPE = null
var SYSTEM_SCENE = null
var DEFENSE_SYSTEM_PROPS = {
	"electro": {
		"type": "time_period_bound",
		"lasting_time_period": 30, # in seconds
		"load_time": 0.5, # in seconds
		"damage_points": 10,
		"scale": Vector2(0.2, 0.2),
		"attack_range_radius": 800
	},
	"electro_grenade": {
		"type": "one_shot",
		"damage_points": 8,
		"scale": Vector2(0.1, 0.1),
		"attack_range_radius": 600
	},
	"nebula_boom": {
		"type": "time_period_bound",
		"lasting_time_period": 30, # in seconds
		"load_time": 0.8, # in seconds
		"damage_points": 20,
		"scale": Vector2(0.2, 0.2),
		"attack_range_radius": 800
	}
}
var ELAPSED_TIME_IN_SECONDS = 0 # in seconds
var ALIEN_BODIES_IN_ATTACK_REGION = []
var ATTACK_RANGE_SPRITE_SIZE = Vector2(1024, 1024)

# variables used for defense systems that have a load time
var TIME_TO_WAIT = 0
var CAN_ACTIVATE = true

# varaibles related to drawing stuff
var LINE_START_POINT = Vector2(0, -30)
var LINE_END_POINTS = []

# scenes used
const ELECTRO = preload("res://scenes/defense_system/defense_system_types/electro.tscn")
const ELECTRO_GRENADE = preload("res://scenes/defense_system/defense_system_types/electro_grenade.tscn")
const NEBULA_BOOM = preload("res://scenes/defense_system/defense_system_types/nebula_boom.tscn")

# child nodes used
@onready var time_bar = $TimeBar
@onready var attack_range_shape_2d = $AttackRange/CollisionShape2D
@onready var attack_range_sprite = $AttackRangeSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(SYSTEM_NAME in DEFENSE_SYSTEM_PROPS.keys(), "Configure the defense system using .init_defense_system")
	
	scale = DEFENSE_SYSTEM_PROPS[SYSTEM_NAME]["scale"]
	attack_range_shape_2d.shape.radius = DEFENSE_SYSTEM_PROPS[SYSTEM_NAME]["attack_range_radius"]
	
	# displaying the attack range sprite
	var attack_range_sprite_scale_factor = (attack_range_shape_2d.shape.radius * 2) / ATTACK_RANGE_SPRITE_SIZE.x
	attack_range_sprite.scale = Vector2(attack_range_sprite_scale_factor, attack_range_sprite_scale_factor)
	if SYSTEM_NAME != "electro":
		attack_range_sprite.visible = true
	else:
		attack_range_sprite.visible = false
	
	# displaying the time bar
	if SYSTEM_NAME != "electro_grenade":
		time_bar.visible = true
	else:
		time_bar.visible = false
	
	# initialising the defense system scene
	match SYSTEM_NAME:
		"electro":
			SYSTEM_SCENE = ELECTRO.instantiate()
		"electro_grenade":
			SYSTEM_SCENE = ELECTRO_GRENADE.instantiate()
		_:
			SYSTEM_SCENE = NEBULA_BOOM.instantiate()
	add_child(SYSTEM_SCENE)
	
func init_defense_system(defense_system_name: String):
	SYSTEM_NAME = defense_system_name
	SYSTEM_TYPE = DEFENSE_SYSTEM_PROPS[SYSTEM_NAME]["type"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# resetting what was drawn
	LINE_END_POINTS = []
	queue_redraw()
	
	_handle_system_activation()
	
	if SYSTEM_TYPE == "time_period_bound":
		if not CAN_ACTIVATE:
			TIME_TO_WAIT -= delta
			if TIME_TO_WAIT <= 0:
				CAN_ACTIVATE = true
		_update_elapsed_time(delta)
	elif SYSTEM_TYPE == "one_shot":
		if not CAN_ACTIVATE:
			queue_free()
	else:
		pass

func _handle_system_activation():
	if CAN_ACTIVATE and ALIEN_BODIES_IN_ATTACK_REGION.size() > 0:
		SYSTEM_SCENE.activate(ALIEN_BODIES_IN_ATTACK_REGION, DEFENSE_SYSTEM_PROPS[SYSTEM_NAME]["damage_points"])
		CAN_ACTIVATE = false
		if SYSTEM_TYPE == "time_period_bound":
			TIME_TO_WAIT = DEFENSE_SYSTEM_PROPS[SYSTEM_NAME]["load_time"]
		
		# drawing stuff if relevant
		if SYSTEM_NAME == "electro":
			LINE_END_POINTS = SYSTEM_SCENE.get_electro_line_ends()
			queue_redraw()

func _update_elapsed_time(delta):
	ELAPSED_TIME_IN_SECONDS += delta
	var max_lasting_time = DEFENSE_SYSTEM_PROPS[SYSTEM_NAME]["lasting_time_period"]
	_update_time_bar(max_lasting_time)
	if ELAPSED_TIME_IN_SECONDS >= max_lasting_time:
		queue_free()

func _update_time_bar(max_lasting_time):
	time_bar.value = (ELAPSED_TIME_IN_SECONDS/max_lasting_time) * 100

func _on_attack_range_body_entered(body):
	if body.is_in_group("alien"):
		ALIEN_BODIES_IN_ATTACK_REGION.append(body)

func _on_attack_range_body_exited(body):
	if body.is_in_group("alien"):
		if ALIEN_BODIES_IN_ATTACK_REGION.has(body):
			ALIEN_BODIES_IN_ATTACK_REGION.erase(body)

func _draw():
	if SYSTEM_NAME == "electro":
		var line_color = Color(0.282, 0.792, 0.894)
		var line_width = 50
	
		for line_end in LINE_END_POINTS:
			draw_line(LINE_START_POINT, line_end*5, line_color, line_width)
