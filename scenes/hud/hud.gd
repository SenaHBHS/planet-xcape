extends Control

# global variables
const MARGIN = Vector2(10, 10)

# child nodes
@onready var health_bars = $HealthBars
@onready var inventory = $Inventory
@onready var elapsed_time_label = $ElapsedTimeLabel
@onready var din_symbol = $DinSymbol
@onready var din_amount_label = $DinAmountLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	position_dynamic_elements()
	
	# connecting callbacks to signals
	get_viewport().size_changed.connect(position_dynamic_elements)
	SignalManager.din_amount_updated.connect(handle_update_din_amount)
	SignalManager.one_second_elapsed.connect(handle_elapsed_time)
	SignalManager.rerender_inventory_bar.connect(position_inventory_bar)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position_din_amount()

func position_dynamic_elements():
	position_health_bars()
	position_inventory_bar()
	
func position_health_bars():
	var screen_size = get_viewport().size
	# since it is located exactly at 0, 0,
	health_bars.position = MARGIN

func position_inventory_bar():
	var screen_size = get_viewport().size
	var inventory_x_pos = (screen_size.x/2) - ((inventory.size.x*inventory.scale.x)/2)
	var inventory_y_pos = screen_size.y - (inventory.size.y*inventory.scale.y) - MARGIN.y
	inventory.position = Vector2(inventory_x_pos, inventory_y_pos)

func position_din_amount():
	var screen_size = get_viewport().size
	var space_between = 10
	var scale_factor = din_amount_label.scale.x # assumes the scale is the same for both dimensions and the symbol
	
	# determining the y position
	var y_pos = din_amount_label.size.y * scale_factor * 0.5 - 15 # a hard coded up shift of 20
	var extra_y_shift_for_symbol = 16.12
	
	# determining the x positions
	var din_display_combined_width = scale_factor * (din_symbol.size.x + din_amount_label.size.x) + space_between
	var din_symbol_x_pos = screen_size.x - din_display_combined_width - MARGIN.x
	var din_amount_label_x_pos = din_symbol_x_pos + (din_symbol.size.x * scale_factor) + space_between
	
	# setting the position
	din_symbol.position = Vector2(din_symbol_x_pos, y_pos + extra_y_shift_for_symbol)
	din_amount_label.position = Vector2(din_amount_label_x_pos, y_pos)

func handle_update_din_amount(new_amount):
	din_amount_label.text = str(new_amount)

func handle_elapsed_time():
	var elapsed_time_list = ElapsedTimeManager.get_elapsed_time() # a list containing elapsed minutes and seconds

	# converting the time components in the lists to strings for rendering
	for time_component_i in range(elapsed_time_list.size()):
		var time_component = elapsed_time_list[time_component_i]
		if time_component < 10:
			elapsed_time_list[time_component_i] = "0" + str(time_component)
		else:
			elapsed_time_list[time_component_i] = str(time_component)
			
	elapsed_time_label.text = "%s:%s" % [elapsed_time_list[0], elapsed_time_list[1]]
	
