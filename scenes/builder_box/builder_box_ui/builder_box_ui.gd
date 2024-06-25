extends Control

# global variables used
var ITEMS_LIST = [
	{
		"name": "pulse_pistol",
		"price": 100
	},
	{
		"name": "beam_blaster",
		"price": 100
	},
	{
		"name": "plasma_streamer",
		"price": 1000
	},
	{
		"name": "electro_grenade",
		"price": 100
	},
	{
		"name": "electro",
		"price": 100
	},
	{
		"name": "quantum_inferno",
		"price": 100
	},
	{
		"name": "nebula_boom",
		"price": 100
	},
	{
		"name": "extra_slot",
		"price": 100
	},
	{
		"name": "extra_speed",
		"price": 100
	},
	{
		"name": "space_booster",
		"price": LevelManager.get_level_props()["space_booster_price"]
	}
]

# child nodes used
@onready var slots_container = $BuildUi/SlotsContainer
@onready var build_ui = $BuildUi
@onready var din_amount_available = $BuildUi/DinAvailable/HBoxContainer/AmountLabel/Label

# scenes used
const BUILDER_BOX_SLOT = preload("res://scenes/builder_box/builder_box_ui/builder_box_slot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	render_items()
	SignalManager.din_amount_updated.connect(render_items)

func render_items():
	# updating the din amount the user has
	din_amount_available.text = str(DinManager.get_din_amount())
	
	# there are 2 rows
	var n_items_per_row = ITEMS_LIST.size() / 2
	var area_size = slots_container.size
	print(area_size)
	var top_left_pos = slots_container.position
	print(top_left_pos)
	var slot_size = Vector2((area_size.x/n_items_per_row), (area_size.y/2))
	var slot_x_padding = 0 # in pixels
	var slot_y_padding = 0
	var sprite_x_size = slot_size.x - (2*slot_x_padding) # y_size is dynamically calcuated later to maintain the ratio
	
	for i in range(2):
		for item_i in range(n_items_per_row):
			var new_item = BUILDER_BOX_SLOT.instantiate()
			# to maintain the ratio between x and y sizes,
			var sprite_y_size = (new_item.size.y/new_item.size.x) * sprite_x_size
			
			# calculating the position
			var x_pos = top_left_pos.x + (item_i * slot_size.x)
			var y_pos = top_left_pos.y + (i * slot_size.y)
			var sprite_x_pos = x_pos + (slot_size.x/2 - sprite_x_size/2)
			var sprite_y_pos = y_pos + (slot_size.y/2 - sprite_y_size/2)
			print("Slot Size: ", slot_size)
			print("Pos: ", x_pos, " ", y_pos)
			print("Sprite Pos: ", sprite_x_pos, " ", sprite_y_pos)
			
			# applying the size and position props
			new_item.scale = Vector2(sprite_x_size, sprite_y_size) / Vector2(new_item.size.x, new_item.size.y)
			new_item.position = Vector2(sprite_x_pos, sprite_y_pos)
			
			item_i += n_items_per_row * i
			var item_props = ITEMS_LIST[item_i]
			
			# calculating whether the player can afford the item
			var is_affordable
			if DinManager.get_din_amount() < item_props["price"]:
				is_affordable = false
			else:
				is_affordable = true
				
			# intialising the slot
			new_item.init_slot(item_props["name"], item_props["price"], is_affordable)
			
			build_ui.add_child(new_item)
