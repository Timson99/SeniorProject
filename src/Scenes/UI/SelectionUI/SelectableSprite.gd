extends Control

class_name SpriteSelectable

func select():
	$AnimatedSprite.play("selected")
	
func deselect():
	$AnimatedSprite.play("deselected")
	
func get_value():
	return $RichTextLabel.text
	
func set_value(value):
	$RichTextLabel.text = value
