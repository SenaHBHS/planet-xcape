extends Node

# din is the in-game currency!

var _din_amount = 0

func _set_din_amount(amount):
	_din_amount = amount
	SignalManager.update_din_amount.emit(_din_amount)

func get_din_amount():
	return _din_amount

func increase_din_amount(amount):
	_din_amount += amount
	print("DIN AMOUNT", _din_amount)

func spend_din(amount):
	# player is only allowed to buy stuff if they have enough din
	_din_amount -= amount
