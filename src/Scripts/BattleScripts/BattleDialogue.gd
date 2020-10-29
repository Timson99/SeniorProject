extends Control

#InputEngine
var input_id = "Battle_Dialogue"
onready var text_label = $RichTextLabel

func display_message(message):
	text_label.text = message
