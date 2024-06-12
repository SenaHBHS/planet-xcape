extends CharacterBody2D

@export var ALIEN_NAME = ""

var CURRENT_ALIEN_SCENE = null
var CURRENT_ALIEN_PROPS = null
var ALIEN_PRIMARY_TARGET = null

# alien type scenes that handle animations (these are to  be automatically instantiated)
const COSMIC_GHOST = preload("res://scenes/alien_wave/base_alien/alien_types/cosmic_ghost.tscn")
const ELECTRO_GORGON = preload("res://scenes/alien_wave/base_alien/alien_types/electro_gorgon.tscn")
const NEBULA_GOBLIN = preload("res://scenes/alien_wave/base_alien/alien_types/nebula_goblin.tscn")
const STELLAR_BEARD = preload("res://scenes/alien_wave/base_alien/alien_types/stellar_beard.tscn")

# in game variables
var ALIEN_MODE = "move" # either attack or move
var PLAYER_CAN_ATTACK = false # used to respond to a fist hit from the player

# global variables related to attacking
var ALIGNED_WITH_TARGET = false
var TARGET_POS = null # used for the position of objects not accessible through game manager
# used to make sure the alien is aligned with the player
var REPOSITIONING_ALIEN = false

# nodes in the base alien that are dynamically adjusted
@onready var alien_collision_shape_2d = $AlienCollisionShape2D
@onready var alien_body_shape_2d = $AlienBodyArea/AlienBodyShape2D
@onready var attack_range_shape_2d = $AttackRangeArea/AttackRangeShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(ALIEN_NAME != null, "Please set the alien name using set_alien(name)")
	set_alien("nebula_goblin")

func set_alien(name: String) -> void:
	ALIEN_NAME = name
	
	# there are only 4 possible names!
	if ALIEN_NAME == "cosmic_ghost":
		CURRENT_ALIEN_SCENE = COSMIC_GHOST.instantiate()
	elif ALIEN_NAME == "electro_gorgon":
		CURRENT_ALIEN_SCENE = ELECTRO_GORGON.instantiate()
	elif ALIEN_NAME == "nebula_goblin":
		CURRENT_ALIEN_SCENE = NEBULA_GOBLIN.instantiate()
	else:
		CURRENT_ALIEN_SCENE = STELLAR_BEARD.instantiate()
	
	# fetching the render_props
	var _render_props = CURRENT_ALIEN_SCENE.get_render_props()
	
	# applying the render_props
	_apply_render_props(_render_props)
	
	# adding the scene to the BaseAlien
	add_child(CURRENT_ALIEN_SCENE)
	
	# fetching the alien props
	CURRENT_ALIEN_PROPS = CURRENT_ALIEN_SCENE.get_alien_props()
	ALIEN_PRIMARY_TARGET = CURRENT_ALIEN_PROPS["primary_target"]

func _apply_render_props(render_props: Dictionary) -> void:
	# configuring the scale
	scale = render_props["scale"]
	# configuring the alien's body shape (there are 2 duplicates: one for BaseAlien and the other for Area2D)
	alien_body_shape_2d.shape.radius = render_props["player_body_area_radius"]
	alien_body_shape_2d.shape.height = render_props["player_body_area_height"]
	alien_collision_shape_2d.shape.radius = render_props["player_body_area_radius"]
	alien_collision_shape_2d.shape.height = render_props["player_body_area_height"]
	
	# configuring the attack range
	attack_range_shape_2d.shape.radius = render_props["player_attack_range_radius"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if ALIEN_MODE == "move":
		handle_motion()
	else:
		handle_attack()

func _get_velocity_vector(target: Vector2) -> Vector2:
	var delta_x = target.x - position.x
	var delta_y = target.y - position.y
	var delta_vector = Vector2(delta_x, delta_y)
	
	var theta = atan(abs(delta_y)/abs(delta_x))
	var direction_vec = Vector2(cos(theta), sin(theta)) # the hypotenuse is 1
	
	if delta_vector.x < 0:
		direction_vec.x *= -1
	if delta_vector.y < 0:
		direction_vec.y *= -1
		
	return direction_vec * CURRENT_ALIEN_PROPS["speed"]

func handle_motion():
	if ALIEN_PRIMARY_TARGET == "player":
		velocity = _get_velocity_vector(GameManager.get_player_position())
	else:
		velocity = _get_velocity_vector(GameManager.get_rocket_position())
		
	move_and_slide()

func _align_with_the_target(target_pos: Vector2) -> void:
	# this make sures the alien always attacks the player such that both can shoot bullets to each other!
	var delta_x = position.x - target_pos.x
	var delta_y = position.y - target_pos.y
	
	if abs(delta_y) > 5:
		REPOSITIONING_ALIEN = true
		
		var shifter = 120
		var shifted_target_pos = target_pos
		if delta_x >= 0:
			shifted_target_pos.x += shifter
			velocity = _get_velocity_vector(shifted_target_pos)
		else:
			shifted_target_pos.x -= shifter
			velocity = _get_velocity_vector(shifted_target_pos)
	
		move_and_slide()
	else:
		REPOSITIONING_ALIEN = false
		# moving the alien again so that player is inside the attack range
		if abs(delta_x) >= CURRENT_ALIEN_SCENE.get_render_props()["player_attack_range_radius"]:
			ALIEN_MODE = "move"

func handle_attack():
	if ALIEN_PRIMARY_TARGET == "player":
		SignalManager.player_was_hit.emit(CURRENT_ALIEN_PROPS["damage_per_attack"])
		_align_with_the_target(GameManager.PLAYER_POS)
	else:
		_align_with_the_target(TARGET_POS)

func _on_attack_range_body_entered(body):
	# changing the alien mode based on their primary target
	if ALIEN_MODE != "attack" and body.is_in_group(ALIEN_PRIMARY_TARGET):
		ALIEN_MODE = "attack"
		TARGET_POS = body.position

func _on_attack_range_body_exited(body):
	if not REPOSITIONING_ALIEN:
		if ALIEN_MODE != "move" and body.is_in_group(ALIEN_PRIMARY_TARGET):
			ALIEN_MODE = "move"
			ALIGNED_WITH_TARGET = false
			TARGET_POS = null

func _on_alien_body_area_body_entered(body):
	if body.is_in_group("player"):
		PLAYER_CAN_ATTACK = true

func _on_alien_body_area_body_exited(body):
	if body.is_in_group("player"):
		PLAYER_CAN_ATTACK = false
		ALIGNED_WITH_TARGET = false
