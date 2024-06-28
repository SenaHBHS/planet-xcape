extends Node2D

@onready var builder_box_ui = $CanvasLayer/BuilderBoxUi

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.set_builder_box_opened.connect(handle_builder_box)

func handle_builder_box(is_open: bool):
	if is_open:
		builder_box_ui.visible = true
	else:
		builder_box_ui.visible = false
