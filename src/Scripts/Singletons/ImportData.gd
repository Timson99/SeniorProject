extends Node

var item_data

# Called when the node enters the scene tree for the first time.
func _ready():
	var itemdata_file = File.new()
	itemdata_file.open("res://Scenes/Luis_Test_Scenes/Data/Item Table - Sheet1.json", File.READ)
	var itemdata_json = JSON.parse(itemdata_file.get_as_text())
	itemdata_file.close()
	item_data = itemdata_json.result
	print(item_data)
