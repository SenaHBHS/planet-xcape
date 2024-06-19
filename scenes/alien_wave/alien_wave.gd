extends Node2D

# general global variables
var DIFFICULTY = 1 # to make the game progressively challenging (changes the alien speed and wait time based on this)
var DIFFICUTLY_INCREASE_PER_WAVE_SPAWNED = 0.02
var RANDOM_NUM_GEN = RandomNumberGenerator.new()
# following are automatically configured in ready()
var SCREEN_SIZE = null
var ALIEN_TYPES = null

# global variables used to spawn aliens
var SPAWN_AREA = Vector2(10, 10) # a margin added to the screen size to spawn aliens
var MIN_RADIAL_LEN_BETWEEN_ALIENS = 100
var SPAWNING_WAVE = false
var CAN_SPAWN_SUBWAVE = true
var N_SUBWAVES_TO_SPAWN = 0
# following are later on configured
var LOWER_N_ALIEN_BOUND = null
var WAIT_TIME_BEFORE_SUBWAVE = null

# scenes used
const BASE_ALIEN = preload("res://scenes/alien_wave/base_alien/base_alien.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	_update_screen_size()
	get_viewport().connect("size_changed", _update_screen_size)
	LOWER_N_ALIEN_BOUND = LevelManager.get_level_props()["lower_n_alien_bound"]
	ALIEN_TYPES = AlienWaveManager.get_alien_types()

func _update_screen_size():
	SCREEN_SIZE = get_viewport().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	spawn_alien_wave()

func spawn_alien_wave():
	if not SPAWNING_WAVE:
		if AlienWaveManager.can_spawn_a_wave:
			SPAWNING_WAVE = true
			CAN_SPAWN_SUBWAVE = true
			N_SUBWAVES_TO_SPAWN = LevelManager.get_level_props()["n_subwaves"]
		else:
			pass
	else:
		if N_SUBWAVES_TO_SPAWN > 0:
			var n_extra_aliens = RANDOM_NUM_GEN.randi_range(0, 2)
			var n_aliens_to_spawn = LOWER_N_ALIEN_BOUND + n_extra_aliens
		else:
			DIFFICULTY += DIFFICUTLY_INCREASE_PER_WAVE_SPAWNED
			SPAWNING_WAVE = false
			AlienWaveManager.set_can_spawn_a_wave_to_false()

func _spawn_aliens(count: int):
	var spawned_coordinates = []
	
	for i in range(count):
		var still_spawning_alien = true # used to continuously repeat the code until a good coordinate is found
		while still_spawning_alien:
			var random_spawn_cors = _get_random_alien_spawn_coordinates(spawned_coordinates)
			if random_spawn_cors != Vector2(0, 0):
				still_spawning_alien = false
				spawned_coordinates.append(random_spawn_cors)
			else:
				continue
			
			# choosing a random alien type
			var random_alien_type_index = RANDOM_NUM_GEN.randi_range(0, ALIEN_TYPES.size() - 1)
			var alien_type = ALIEN_TYPES[random_alien_type_index]
			
			# instantiating the new alien
			var new_alien = BASE_ALIEN.instantiate()
			new_alien.set_alien(alien_type)
			new_alien.position = random_spawn_cors
			get_parent().add_child(new_alien)

func _get_random_alien_spawn_coordinates(spawned_coordinates: Array) -> Vector2:
	# by default, if a valid coordinate for the alien is not found Vector2(0, 0) would be returned
	
	# generating a random_coordinate (each possibility is stored in a list)
	var random_x_cors = []
	random_x_cors.append(RANDOM_NUM_GEN.randi_range(0-SPAWN_AREA.x, 0)) # left end x cor
	random_x_cors.append(RANDOM_NUM_GEN.randi_range(SPAWN_AREA.x, SCREEN_SIZE.x + SPAWN_AREA.x)) # right end x cor
	
	var random_y_cors = []
	random_y_cors.append(RANDOM_NUM_GEN.randi_range(0-SPAWN_AREA.y, 0)) # top end y cor
	random_y_cors.append(RANDOM_NUM_GEN.randi_range(SPAWN_AREA.y, SCREEN_SIZE.y + SPAWN_AREA.y)) # bottom end y cor
	
	# there are 2 possible random coordinates
	var random_cor_one = Vector2(random_x_cors[0], random_y_cors[0])
	var random_cor_two = Vector2(random_x_cors[1], random_y_cors[1])
	
	if _is_alien_cor_valid(random_cor_one, spawned_coordinates):
		return random_cor_one
	elif _is_alien_cor_valid(random_cor_two, spawned_coordinates):
		return random_cor_two
	else:
		# this implies that a valid coordiate was not found
		return Vector2(0, 0)
	
func _is_alien_cor_valid(selected_coordinate: Vector2, spawned_coordinates: Array) -> bool:
	# returns if the coordinate is valid or not
	for spawned_coordinate in spawned_coordinates:
		var delta_x = spawned_coordinate.x - selected_coordinate.x
		var delta_y = spawned_coordinate.y - selected_coordinate.y
		
		var radial_length = sqrt(delta_x**2 + delta_y**2)
		
		if radial_length < MIN_RADIAL_LEN_BETWEEN_ALIENS:
			return false
			
	# if the code reaches this, all the selected_coordinate is valid
	return true
