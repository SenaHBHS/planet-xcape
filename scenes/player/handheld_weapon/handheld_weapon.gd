extends Area2D

@onready var weapon_sprite_2d = $WeaponSprite2D
@onready var weapon_animation = $WeaponAnimation

# global variables
var DIRECTION = "right" # by default
var RENDER_PROPERTIES = {
	"beam_blaster": {
		"scale": Vector2(1, 1),
		"position": Vector2(0, 0)
	},
	"plasma_streamer": {
		"scale": Vector2(1, 1),
		"position": Vector2(0, 0)
	},
	"pulse_pistol": {
		"scale": Vector2(0.8, 0.8),
		"position": Vector2(10, 0)
	}
}

func set_direction(direction: String) -> void:
	if direction == "right":
		weapon_sprite_2d.flip_h = false
		DIRECTION = "right"
	else:
		weapon_sprite_2d.flip_h = true
		DIRECTION = "left"

func fire() -> void:
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
	
	var selected_weapon_inventory_obj = InventoryManager.get_current_item()
	selected_weapon_inventory_obj["hp_points"] -= 1
	
	# dealing with the weapon's lifetime
	if selected_weapon_inventory_obj["hp_points"] <= 0:
		InventoryManager.remove_item(InventoryManager.selected_pos)
