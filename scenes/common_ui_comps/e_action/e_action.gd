extends Node2D

@onready var action_text_label = $ActionTextLabel
var ACTION_TEXT = "CHECK!"

func _ready():
	action_text_label.text = ACTION_TEXT

func set_action_text(text: String):
	ACTION_TEXT = text
