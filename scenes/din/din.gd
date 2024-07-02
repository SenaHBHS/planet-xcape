extends Area2D

var DIN_VALUE = null

# here, each key is the lower bound (color is valid if the DIN_VALUE > the key)
# these must be arranged in descending order!
var DIN_SKINS = {
	10: Color(39 / 255.0, 183 / 255.0, 255 / 255.0),
	5: Color(196 / 255.0, 150 / 255.0, 38 / 255.0),
	0: Color(1, 1, 1)
}

# child nodes used
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(DIN_VALUE != null, "Please configure the din value using config_din(value)")
	_set_din_skin()
	animation_player.play("idle")

func config_din(din_value: int):
	DIN_VALUE = din_value

func _set_din_skin():
	var din_skins_keys = DIN_SKINS.keys()
	var din_skins_values = DIN_SKINS.values()
	
	if DIN_VALUE > int(din_skins_keys[0]):
		sprite_2d.self_modulate = din_skins_values[0]
	elif DIN_VALUE > int(din_skins_keys[1]):
		sprite_2d.self_modulate = din_skins_values[1]
	else:
		sprite_2d.self_modulate = din_skins_values[2]

func _on_body_entered(body):
	# both the player and the objects (e.g. rocket, builder box) can collect din
	if body.is_in_group("player") or body.is_in_group("object"):
		DinManager.increase_din_amount(DIN_VALUE)
		queue_free()
