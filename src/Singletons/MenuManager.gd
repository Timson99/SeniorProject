extends Node2D

var active = false 

const main_menu_scene = preload("res://Scenes/UI/MainMenuUI/MainMenu.tscn")
var main_menu = null

var item_data
var skill_data
var party = null

func _ready():
	load_item_data()
	load_skill_data()

func activate():	

	party = ActorEngine.get_party()
	EnemyHandler.freeze_all_nonplayers()

	main_menu = main_menu_scene.instance()
	call_deferred("add_child", main_menu)
	main_menu.parent = self
	active = true
	
func deactivate():
	party = null
	main_menu = null
	active = false
	EnemyHandler.unfreeze_all_nonplayers()
	
	
#Loads Item Data on Game Start, Accessed MenuManager.item_data
func load_item_data():
	item_data = ItemsDirectory.items
	
func load_skill_data():
	skill_data = SkillsDirectory.skills
	
	

	

		
	

