extends Control

class_name Item

onready var item_label = $Name
var item_name = "Item"

func _ready():
	item_label.text= item_name
	
func _setup(name):
	item_name= name

	

