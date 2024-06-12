extends Area2D

var RENDER_PROPERTIES = {
	"beam_blaster": {
		"scale": Vector2(0.065, 0.065),
		"capsule_radius": 88,
		"capsule_height": 692,
		"speed": 475,
		"x_offset": 50,
		"y_offset": -5
	},
	"plasma_streamer": {
		"scale": Vector2(0.075, 0.075),
		"capsule_radius": 68,
		"capsule_height": 956,
		"speed": 500,
		"x_offset": 60,
		"y_offset": -10
	},
	"pulse_pistol": {
		"scale": Vector2(0.08, 0.08),
		"capsule_radius": 68,
		"capsule_height": 350,
		"speed": 425,
		"x_offset": 100,
		"y_offset": -10
	},
	"electro_gorgon": {
		"scale": Vector2(0.08, 0.08),
		"capsule_radius": 68,
		"capsule_height": 350,
		"speed": 425,
		"x_offset": 100,
		"y_offset": -10
	}
}

# global variables (null values are expected to be changed upon instantiation)
var BULLET_NAME = null
var BULLET_TYPE = null # either player or alien (aliens can fire bullet too)
var BULLET_DAMAGE = null # how much it damages!
var DIRECTION = "right" # by default

# child nodes of the bullet
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var bullet_area_shape_2d = $Area2D/BulletAreaShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(BULLET_NAME != null, "Please set the configure the bullet using config_bullet()")
	
	# setting up the render properties
	animated_sprite_2d.animation = BULLET_NAME
	scale = RENDER_PROPERTIES[BULLET_NAME]["scale"]
	collision_shape_2d.shape.radius = RENDER_PROPERTIES[BULLET_NAME]["capsule_radius"]
	collision_shape_2d.shape.height = RENDER_PROPERTIES[BULLET_NAME]["capsule_height"]
	bullet_area_shape_2d.shape.radius = RENDER_PROPERTIES[BULLET_NAME]["capsule_radius"]
	bullet_area_shape_2d.shape.height = RENDER_PROPERTIES[BULLET_NAME]["capsule_height"]
	
	if DIRECTION == "right":
		animated_sprite_2d.flip_h = false
		position.x += RENDER_PROPERTIES[BULLET_NAME]["x_offset"]
	else:
		animated_sprite_2d.flip_h = true
		position.x -= RENDER_PROPERTIES[BULLET_NAME]["x_offset"]
	position.y += RENDER_PROPERTIES[BULLET_NAME]["y_offset"]
		
func config_bullet(bullet_name: String, bullet_type: String, damage_per_hit: int) -> void:
	BULLET_NAME = bullet_name
	BULLET_TYPE = bullet_type
	BULLET_DAMAGE = damage_per_hit
	
func get_bullet_damage_amount() -> int:
	return BULLET_DAMAGE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if DIRECTION == "right":
		position.x += delta * RENDER_PROPERTIES[BULLET_NAME]["speed"]
	else:
		position.x -= delta * RENDER_PROPERTIES[BULLET_NAME]["speed"]
		
	# automatically deleting the bullet instance once it goes out of the screen
	var screen_size = get_viewport().size
	if global_position.x < 0 or global_position.x > screen_size.x:
		queue_free()
	else:
		pass

# if the bullet hits something!
func _on_area_2d_body_entered(body):
	print(body)
	queue_free()
