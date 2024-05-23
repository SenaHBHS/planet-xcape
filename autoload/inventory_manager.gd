extends Node

# global game variable management
const inventory_limit = 3 # max n(items) in the inventory!
const available_items = []

var n_available_slots = inventory_limit
var selected_item = null

func add_available_item(item:String) -> bool:
	# returns whether the action was successful or not
	if n_available_slots > 0:
		available_items.append(item)
		n_available_slots -= 1
		return true
	else:
		return false

func remove_an_item(item:String) -> bool:
	# returns whether the action was successful
	# the item must be in available_items
	if item in available_items: 
		n_available_slots += 1
		available_items.erase(item)
		return true
	else:
		return false
