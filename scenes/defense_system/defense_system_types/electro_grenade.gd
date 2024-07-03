extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	animation = "idle"


# activating the defense system (i.e. attacking the aliens)
func activate(alien_bodies_in_attack_region, damage_points):
	for alien_body in alien_bodies_in_attack_region:
		alien_body.deduct_hp_points(damage_points)
