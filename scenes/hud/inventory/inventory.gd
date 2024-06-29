extends Control

# scenes used
const INVENTORY_SLOT = preload("res://scenes/hud/inventory/inventory_slot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	render_inventory_bar()
	SignalManager.rerender_inventory_bar.connect(render_inventory_bar)

func _process(delta):
	# handling user inputs
	if Input.is_action_just_pressed("select_right_inventory"):
		InventoryManager.select_next_item()
	if Input.is_action_just_pressed("select_left_inventory"):
		InventoryManager.select_previous_item()
	# handling num key inputs
	for i in range(9):
		if Input.is_action_just_pressed("inventory_%d"%i):
			InventoryManager.select_item_at_pos(i)

func _remove_all_children():
	for child in get_children():
		child.queue_free()

func _rescale_parent_panel(slot_size: Vector2, n_items: int):
	var new_x_size = slot_size.x * n_items
	size = Vector2(new_x_size, slot_size.y)

func render_inventory_bar():
	_remove_all_children()
	
	var selected_item_i = InventoryManager.selected_pos
	var start_pos = Vector2(0, 0)
	var _slot_size = Vector2(0, 0) # configured in the for loop
	
	for item_i in range(InventoryManager.available_items.size()):
		# extracting the item properties
		var item_props = InventoryManager.available_items[item_i]
		var item_name = item_props["name"]
		var item_category = item_props["category"]
		
		# configuring if it's active
		var is_active = false
		if item_i == selected_item_i:
			is_active = true
		
		# caculating the position
		var inventory_slot = INVENTORY_SLOT.instantiate()
		_slot_size = inventory_slot.size
		var slot_x_pos = start_pos.x + (_slot_size.x * item_i)
		inventory_slot.position = Vector2(slot_x_pos, start_pos.y) # relative to the origin
		
		# initialising the slot
		inventory_slot.init_slot(item_name, item_category, is_active)
		add_child(inventory_slot)
		
	# rescaling the parent panel
	_rescale_parent_panel(_slot_size, InventoryManager.available_items.size())
