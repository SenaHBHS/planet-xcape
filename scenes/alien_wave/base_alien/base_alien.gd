extends CharacterBody2D

@export var ALIEN_NAME = ""

var CURRENT_ALIEN_SCENE = null

# alien type scenes that handle animations (these are to  be automatically instantiated)
const COSMIC_GHOST = preload("res://scenes/alien_wave/base_alien/alien_types/cosmic_ghost.tscn")
const ELECTRO_GORGON = preload("res://scenes/alien_wave/base_alien/alien_types/electro_gorgon.tscn")
const NEBULA_GOBLIN = preload("res://scenes/alien_wave/base_alien/alien_types/nebula_goblin.tscn")
const STELLAR_BEARD = preload("res://scenes/alien_wave/base_alien/alien_types/stellar_beard.tscn")

# nodes in the base alien that are dynamically adjusted
@onready var alien_collision_shape_2d = $AlienCollisionShape2D
@onready var alien_body_shape_2d = $AlienBodyArea/AlienBodyShape2D
@onready var attack_range_shape_2d = $AttackRangeArea/AttackRangeShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(ALIEN_NAME != "", "Please set the alien name using set_alien(name)")

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
func _process(delta):
	pass
