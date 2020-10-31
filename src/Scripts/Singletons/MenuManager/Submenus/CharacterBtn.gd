extends Control

var char_id = null
var stats: Dictionary = {}
var char_sprite = null
func _ready():
	$Sprite.set_texture(char_sprite)
	$ID/Name.text = str(char_id)
	$ID/Level.text = str("Level: ", stats.get("LEVEL"))
	$Condition/HP.text = str("HP: ",stats.get("HP"),"/",stats.get("MAX HP"))
	$Condition/SP.text = str("SP: ",stats.get("SP"),"/",stats.get("MAX SP"))
	

func _setup(name,dict,sprite):
	char_id = name
	stats = dict
	char_sprite = sprite

	

