extends AnimatedSprite2D

var MAX_N_ALIENS_ATTACKED_AT_ONCE = 3
var ELECTRO_LINE_ENDS = [] # a list of Vector2s that store the electro line end points
var ELECTRO_LINE_START = Vector2(0, -30)

# Called when the node enters the scene tree for the first time.
func _ready():
	animation = "idle"

# activating the defense system (i.e. attacking the aliens)
func activate(alien_bodies_in_attack_region, damage_points):
	ELECTRO_LINE_ENDS = []
	alien_bodies_in_attack_region.shuffle()
	
	for i in range(MAX_N_ALIENS_ATTACKED_AT_ONCE):
		if i < alien_bodies_in_attack_region.size():
			var alien_body = alien_bodies_in_attack_region[i]
			ELECTRO_LINE_ENDS.append(alien_body.global_position - global_position)
			alien_body.deduct_hp_points(damage_points)
		
func get_electro_line_ends():
	return ELECTRO_LINE_ENDS
