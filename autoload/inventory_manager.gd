extends Node

# global game variable management
var inventory_limit = 3 # max n(items) in the inventory!
var available_items = []
const dummy_item_template = {
	"name": "",
	"category": "",
}
# main cateogries: weapon, defense_system, object

# these represent indices of the available_items list
var available_slots = []
var selected_pos = 0 # index of the available_items list

var n_available_unlock_slot_power_ups = 6

func _ready():
	_initialize_available_items()
	_deploy_common_funcs()

func _process(_delta):
	if Input.is_action_just_pressed("remove_selected_item"):
		remove_current_item()

func _initialize_available_items() -> void:
	# adding item objects to the list
	for i in range(inventory_limit):
		available_items.append(dummy_item_template.duplicate())
		available_slots.append(i)

# deploy functions related to the current selected position
func _deploy_common_funcs():
	# selected item related functions
	var current_item = available_items[selected_pos]
	if current_item.category == "weapon":
		WeaponManager.change_equipped_weapon(current_item.name)
	else:
		# defaulting the player weapon
		WeaponManager.change_equipped_weapon("fist")
		
	# rerendering the inventory bar
	SignalManager.rerender_inventory_bar.emit()

func add_available_item(item_name:String, item_category:String) -> bool:
	# returns whether the action was successful or not
	if len(available_slots) > 0:
		# selecting the inventory bar postion to store the item
		var inventory_pos = available_slots[0]
		available_slots.remove_at(0) # removing the slot
		
		# filling in the item properties
		available_items[inventory_pos]["name"] = item_name
		available_items[inventory_pos]["category"] = item_category
		
		if item_category == "weapon":
			available_items[inventory_pos]["hp_points"] = WeaponManager.get_props_for_weapon(item_name)["hp_points"]
		
		_deploy_common_funcs()
		
		return true
	else:
		return false

func get_current_item() -> Dictionary:
	return available_items[selected_pos]

func remove_current_item() -> void:
	if selected_pos not in available_slots:
		# making the current position available
		available_slots.append(selected_pos)
		# sorting the available positions
		available_slots.sort()
		
		# emptying the item
		available_items[selected_pos]["name"] = ""
		available_items[selected_pos]["category"] = ""
		_deploy_common_funcs()

func select_next_item() -> void:
	if selected_pos < len(available_items) - 1:
		selected_pos += 1
	else:
		pass
		
	_deploy_common_funcs()

func select_previous_item() -> void:
	if selected_pos > 0:
		selected_pos -= 1
	else:
		pass
		
	_deploy_common_funcs()

func select_item_at_pos(inventory_pos: int) -> void:
	if inventory_pos >= 0 and inventory_pos < len(available_items):
		selected_pos = inventory_pos
		_deploy_common_funcs()

# this is available as a power-up
func unlock_an_extra_slot() -> void:
	available_slots.append(available_items.size())
	available_items.append(dummy_item_template.duplicate())
	inventory_limit += 1
	n_available_unlock_slot_power_ups -= 1
	
	_deploy_common_funcs()

func check_unlock_slot_availability() -> bool:
	# need to make sure what would happen if one more power up was purchasedd
	if n_available_unlock_slot_power_ups < 1:
		return false
	else:
		return true
