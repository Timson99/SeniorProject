extends Control

func select():
	$AnimatedSprite.play("on")
	
func deselect():
	$AnimatedSprite.play("off")
	
func get_value():
	return $SaveName.text
	
func set_value(value):
	$SaveName.text = value
	$DataAvailable.text = "Has Data" if FileTools.save_file_exists($SaveName.text) else "No Data"

