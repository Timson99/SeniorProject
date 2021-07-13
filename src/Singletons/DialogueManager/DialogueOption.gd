extends Control

var option_data : Dictionary 

func select():
	$msg.bbcode_text = "[color=#00ff00]" + option_data["text"] + "[/color]"
	
func deselect():
	$msg.bbcode_text = option_data["text"]
	
func get_value():
	return option_data
	
func set_value(value):
	option_data = value
	$msg.text = value["text"]


