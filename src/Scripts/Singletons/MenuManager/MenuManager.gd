extends Node2D

var active = false 

const main_menu_scene = preload("res://Scripts/Singletons/MenuManager/MainMenu.tscn")
var main_menu = null

var item_data
const item_data_file = "res://Scenes/Luis_Test_Scenes/Data/Item Table - Sheet1.json"

func _ready():
	load_item_data()

func activate():	
	main_menu = main_menu_scene.instance()
	call_deferred("add_child", main_menu)
	main_menu.parent = self
	active = true
	
func deactivate():
	main_menu = null
	active = false
	
	
#Loads Item Data on Game Start, Accessed MenuManager.item_data
func load_item_data():
	var itemdata_file = File.new()
	itemdata_file.open(item_data_file, File.READ)
	var itemdata_json = JSON.parse(itemdata_file.get_as_text())
	itemdata_file.close()
	item_data = itemdata_json.result
	print(item_data)

	
	

	

		
	

