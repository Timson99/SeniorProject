extends Control

var option_data : Dictionary 

func select():
	$Sprite.show()
	
func deselect():
	$Sprite.hide()
	
func get_value():
	return option_data
	
func set_value(value):
	option_data = value
	$msg.text = value["text"]


