extends StaticBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func fire():
	# this assumes it is called after making sure the equipped weapon is handheld
	animated_sprite_2d.animation = WeaponManager.equipped_weapon
	print("Fired") # this must instantiate a bullet scene
	animation_player.play("default_fire_movement")
	# TODO: increase the n_times fired and delete delete the available item if the limit exceeds
	
