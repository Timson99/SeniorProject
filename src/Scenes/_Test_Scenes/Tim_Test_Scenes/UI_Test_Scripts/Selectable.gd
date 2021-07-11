extends Control

func select():
	$AnimatedSprite.play("selected")
	
func deselect():
	$AnimatedSprite.play("deselected")
	
func get_value():
	return $RichTextLabel.text
