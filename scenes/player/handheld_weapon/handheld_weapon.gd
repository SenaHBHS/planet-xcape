extends StaticBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer

func fire():
	# this assumes it is called after making sure the equipped weapon is handheld
	animated_sprite_2d.animation = WeaponManager.equipped_weapon
	animation_player.play("default_fire_movement")
	
	
	# TODO: increase the n_times fired and delete delete the available item if the limit exceeds
	
	# dealing with the weapon's lifetime
