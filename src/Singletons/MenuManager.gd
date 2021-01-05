extends Node2D

var active = false 

const main_menu_scene = preload("res://Scenes/UI/MainMenuUI/MainMenu.tscn")
var main_menu = null

var item_data
const item_data_file = "res://Classes/Directories/ItemData.json"
#const item_data_file = "res://Scenes/Luis_Test_Scenes/Data/Item Table - Sheet1.json"
var skill_data
const skill_data_file = "res://Scenes/_Test_Scenes/Luis_Test_Scenes/Data/Skill Table - Sheet1.json"
var party = null

func _ready():
	load_item_data()
	load_skill_data()

func activate():	
	party = get_tree().get_nodes_in_group("Party")[0]
	main_menu = main_menu_scene.instance()
	call_deferred("add_child", main_menu)
	main_menu.parent = self
	active = true
	
func deactivate():
	party = null
	main_menu = null
	active = false
	
	
#Loads Item Data on Game Start, Accessed MenuManager.item_data
func load_item_data():
	var itemdata_file = File.new()
	itemdata_file.open(item_data_file, File.READ)
	var itemdata_json = JSON.parse(itemdata_file.get_as_text())
	itemdata_file.close()
	item_data = itemdata_json.result
	
func load_skill_data():
	var itemdata_file = File.new()
	itemdata_file.open(skill_data_file, File.READ)
	var itemdata_json = JSON.parse(itemdata_file.get_as_text())
	itemdata_file.close()
	skill_data = itemdata_json.result
	
	

	

		
	

