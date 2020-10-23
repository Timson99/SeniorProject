extends Node2D

var active = false 

const main_menu_scene = preload("res://Scripts/Singletons/MenuManager/MainMenu.tscn")
var main_menu = null


func activate():	
	main_menu = main_menu_scene.instance()
	call_deferred("add_child", main_menu)
	main_menu.parent = self
	active = true
	
func deactivate():
	call_deferred("remove_child", main_menu)
	main_menu = null
	active = false
	
	

	

		
	

