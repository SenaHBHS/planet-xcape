extends Node

# din is the in-game currency!

var _din_amount = 0

func set_din_amount(amount):
	_din_amount = amount
	SignalManager.din_amount_updated.emit(_din_amount)

func get_din_amount():
	return _din_amount

func increase_din_amount(amount):
	SignalManager.din_collected.emit()
	set_din_amount(_din_amount + amount)

func spend_din(amount):
	# returns whether the transaction was succesful!
	if amount <= _din_amount:
		set_din_amount(_din_amount - amount)
		return true
	else:
		return false
