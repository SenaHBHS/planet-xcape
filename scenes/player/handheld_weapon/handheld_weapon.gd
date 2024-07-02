extends Area2D

@onready var weapon_sprite_2d = $WeaponSprite2D
@onready var weapon_animation = $WeaponAnimation
# sound players
@onready var beam_blaster_player = $BeamBlasterPlayer
@onready var pulse_pistol_player = $PulsePistolPlayer
@onready var plasma_streamer_player = $PlasmaStreamerPlayer

# global variables
var DIRECTION = "right" # by default
var RENDER_PROPERTIES = {
	"beam_blaster": {
		"scale": Vector2(1, 1),
		"position": Vector2(0, 0),
	},
	"plasma_streamer": {
		"scale": Vector2(1, 1),
		"position": Vector2(0, 0),
	},
	"pulse_pistol": {
		"scale": Vector2(0.8, 0.8),
		"position": Vector2(10, 0),
	}
}

const BULLET = preload("res://scenes/bullet/bullet.tscn")

func set_direction(direction: String) -> void:
	if direction == "right":
		weapon_sprite_2d.flip_h = false
		DIRECTION = "right"
	else:
		weapon_sprite_2d.flip_h = true
		DIRECTION = "left"

func fire() -> int:
	"""
	Fires the selected weapon and returns the amount of time it takes to get loaded again!
	"""
	# this assumes it is called after making sure the equipped weapon is handheld
	var current_weapon_name = WeaponManager.equipped_weapon
	var current_weapon_props = WeaponManager.get_props_for_weapon(current_weapon_name)
	
	# adjusting the position and scale to match with the weapon
	weapon_sprite_2d.position = RENDER_PROPERTIES[current_weapon_name]["position"]
	weapon_sprite_2d.scale = RENDER_PROPERTIES[current_weapon_name]["scale"]
	
	# playing necessary animations
	weapon_sprite_2d.animation = current_weapon_name
	if DIRECTION == "right":
		weapon_animation.play("fire_right")
	else:
		weapon_animation.play("fire_left")
	
	# firing the bullet
	var fired_bullet = BULLET.instantiate()
	fired_bullet.position = global_position
	fired_bullet.DIRECTION = DIRECTION
	fired_bullet.config_bullet(current_weapon_name, "player", current_weapon_props["damage_per_hit"])
	# adding this to the root game node!
	get_parent().get_parent().add_child(fired_bullet)
	
	# playing the sound
	if OptionsManager.get_options_dict()["sound"]:
		if current_weapon_name == "plasma_streamer":
			plasma_streamer_player.play()
		elif current_weapon_name == "beam_blaster":
			beam_blaster_player.play()
		else:
			pulse_pistol_player.play()
	
	# emitting the signal!
	SignalManager.player_fired.emit()
	SignalManager.rerender_inventory_bar.emit()
	
	return current_weapon_props["load_time"]
	
