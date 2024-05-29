extends Node

# global game variable management
var inventory_limit = 3 # max n(items) in the inventory!
var available_items = [{
	"name": "plasma_streamer",
	"category": "weapon",
	"hp_points": 100
}] # this has a default item for testing purposes
const dummy_item_template = {
	"name": "",
	"category": ""
}
# main cateogries: weapon, grenade, defense_system, object

# these represent indices of the available_items list
var available_slots = []
var selected_pos = 0 # index of the available_items list

func _ready():
	_initialize_available_items()
	_deploy_funcs_for_selected()

func _initialize_available_items() -> void:
	# adding item objects to the list
	for i in range(inventory_limit):
		available_items.append(dummy_item_template)
		available_slots.append(i)

# deploy functions related to the current selected position
func _deploy_funcs_for_selected():
	var current_item = available_items[selected_pos]
	if current_item.category == "weapon":
		WeaponManager.change_equipped_weapon(current_item.name)
	else:
		# defaulting the player weapon
		WeaponManager.change_equipped_weapon("fist")

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
		
		return true
	else:
		return false

func get_current_item() -> Dictionary:
	return available_items[selected_pos]

func remove_item(inventory_pos:int) -> void:
	# returns whether the action was successful
	available_slots.append(inventory_pos)
	available_items[inventory_pos]["name"] = ""
	available_items[inventory_pos]["category"] = ""

func select_next_item() -> void:
	if selected_pos < len(available_items) - 1:
		selected_pos += 1
	else:
		pass
		
	_deploy_funcs_for_selected()

func select_previous_item() -> void:
	if selected_pos > 0:
		selected_pos -= 1
	else:
		pass
		
	_deploy_funcs_for_selected()

# this is available as a power-up
func unlock_an_extra_slot() -> void:
	available_items.append(dummy_item_template)
	available_slots.append(inventory_limit - 1)
	inventory_limit += 1
