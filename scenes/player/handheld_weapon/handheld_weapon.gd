extends StaticBody2D

@onready var weapon_sprite_2d = $WeaponSprite2D
@onready var weapon_animation = $WeaponAnimation

func fire():
	# this assumes it is called after making sure the equipped weapon is handheld
	var current_weapon_name = WeaponManager.equipped_weapon
	var current_weapon_props = WeaponManager.get_props_for_weapon(current_weapon_name)
	
	# playing necessary animations
	weapon_sprite_2d.animation = current_weapon_name
	weapon_animation.play("default_fire_movement")
	
	var selected_weapon_inventory_obj = InventoryManager.get_current_item()
	selected_weapon_inventory_obj["hp_points"] -= 1
	
	# dealing with the weapon's lifetime
	if selected_weapon_inventory_obj["hp_points"] <= 0:
		InventoryManager.remove_item(InventoryManager.selected_pos)
