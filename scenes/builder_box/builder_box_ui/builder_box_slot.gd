extends Panel

# the price tag is shifted along the x axis to make it appear centred
# each key is the max number within that range
# 9999 is the maximum!
var PRICE_TAG_X_OFFSETS = {
	"10": 0,
	"100": 0,
	"1000": 0,
	"10000": -33.5
}

# each item is given a category based on their name (used for the inventory)
var ITEM_CATEGORIES = {
	"weapon": ["pulse_pistol", "beam_blaster", "plasma_streamer"],
	"defense_system": ["electro_grenade", "electro", "quantum_inferno", "nebula_boom"],
	"power_up": ["extra_slot", "extra_speed", "heal"],
	"object": ["space_booster"]
}

# the following are assigned when initialise_slot()
var NAME = "plasma_streamer"
var PRICE = 500
var AVAILABLE = true
var CATEGORY = null
var PERMENANTELY_UNAVAILABLE = false # this is used for extra inventory slots (once the player reaches the limit)
var INVENTORY_FULL = false

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var price_tag = $PriceTag/Price
@onready var price_label = $PriceTag/Price/HBoxContainer/PriceLabel/Label
@onready var audio_stream_player = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(NAME != name, "Please initialize the slot using init_slot")
	animated_sprite_2d.animation = NAME
	tooltip_text = _snake_to_title_case(NAME)
	price_label.text = str(PRICE)
	set_availability(AVAILABLE)
	
	for range_max in PRICE_TAG_X_OFFSETS.keys():
		if PRICE < int(range_max):
			price_tag.position.x += PRICE_TAG_X_OFFSETS[range_max]
			break
		else:
			continue
	
	# connecting signals
	SignalManager.din_amount_updated.connect(handle_din_amount_change)

func _process(_delta):
	if InventoryManager.available_slots.size() == 0 and CATEGORY != "power_up":
		INVENTORY_FULL = true
		set_availability(false)
	else:
		INVENTORY_FULL = false
		handle_din_amount_change(DinManager.get_din_amount())
	
func init_slot(item_name: String, item_price: int, is_available: bool):
	NAME = item_name
	PRICE = item_price
	AVAILABLE = is_available
	
	for cat in ITEM_CATEGORIES.keys():
		if NAME in ITEM_CATEGORIES[cat]:
			CATEGORY = cat

func handle_din_amount_change(current_din_amount: int):
	if PRICE <= current_din_amount:
		set_availability(true)
	else:
		set_availability(false)

func set_availability(new_availability: bool):
	if !PERMENANTELY_UNAVAILABLE:
		AVAILABLE = new_availability
		if AVAILABLE:
			modulate = Color(1, 1, 1, 1)
			mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		else:
			modulate = Color(1, 1, 1, 0.4)
			mouse_default_cursor_shape = Control.CURSOR_ARROW
	else:
		# if it's permenantly unavailable, it's already set to unavailable
		pass

func purchase_item():
	if !PERMENANTELY_UNAVAILABLE and not INVENTORY_FULL:
		var was_succesful = DinManager.spend_din(PRICE)
		if was_succesful:
			if CATEGORY != "power_up":
				InventoryManager.add_available_item(NAME, CATEGORY)
			else:
				# giving the user power ups
				if NAME == "extra_slot":
					InventoryManager.unlock_an_extra_slot()
					
					var can_unlock_a_new_slot_next_time = InventoryManager.check_unlock_slot_availability()
					if not can_unlock_a_new_slot_next_time:
						set_availability(false)
						PERMENANTELY_UNAVAILABLE = true
						animation_player.play("RESET")
				elif NAME == "heal":
					SignalManager.player_health_powered_up.emit()
				else:
					# this a speed boost
					SignalManager.player_speed_powered_up.emit()
			
			# playing the sound
			if OptionsManager.get_options_dict()["sound"]:
				audio_stream_player.play()
func _snake_to_title_case(snake_case_str: String) -> String:
	var parts = snake_case_str.split("_")
	for i in range(parts.size()):
		parts[i] = parts[i].capitalize()
	return " ".join(parts)

func _on_mouse_entered():
	if AVAILABLE:
		animation_player.play("hovered")

func _on_mouse_exited():
	animation_player.play("RESET")

func _on_gui_input(event):
	if event.is_action_pressed("purchase_item"):
		purchase_item()
