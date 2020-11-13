extends CanvasLayer

export (Array, String) var enemies_debug_keys

onready var enemy_container = $HBoxContainer

var enemy_keys := []
var enemies := []
var selected_enemy_index = 0
onready var battle_brain = SceneManager.current_scene

var selected_material = preload("res://Resources/Shaders/Illumination.tres")

func _ready():
	$HBoxContainer.rect_size = Vector2(0,0)
	var enemy_keys = EnemyHandler.queued_battle_enemies 

	if enemy_keys.size() == 0 and enemies_debug_keys.size() != 0:
		enemy_keys = enemies_debug_keys
	elif enemies_debug_keys.size() == 0 && enemy_keys.size() == 0: 
		return

	for e in enemy_keys:
		var enemy_data = EnemyHandler.Enemies.enemy_types[e]
		var enemy_scene = load(enemy_data["battle_sprite_scene"]).instance()
		var enemy_stats = enemy_data["battle_data"]
		enemy_scene.stats = enemy_stats
		enemy_scene.party = self
		enemy_scene.screen_name = e
		enemy_scene.selected_material = selected_material
		enemy_container.add_child(enemy_scene)
	enemies = enemy_container.get_children()
	
func check_alive():
	for e in enemies:
		if e.alive:
			return
	battle_brain.battle_victory()
	

func select_current():
	if enemies[selected_enemy_index].alive:
		enemies[selected_enemy_index].select()
	else:
		select_right()
	
func deselect_current():
	enemies[selected_enemy_index].deselect()
	selected_enemy_index = 0

func select_right():
	if(enemies.size() <= 1):
		return
	enemies[selected_enemy_index].deselect()
	selected_enemy_index += 1
	selected_enemy_index = min(selected_enemy_index, enemies.size() - 1)

	if(!enemies[selected_enemy_index].alive):
		if(selected_enemy_index ==  enemies.size() - 1):
			select_left()
		else:
			select_right()
	enemies[selected_enemy_index].select()
	
	
func select_left():
	if(enemies.size() <= 1):
		return
	enemies[selected_enemy_index].deselect()
	selected_enemy_index -= 1
	selected_enemy_index = max(selected_enemy_index, 0)

	if(!enemies[selected_enemy_index].alive):
		if(selected_enemy_index == 0):
			select_right()
		else:
			select_left()
	
	enemies[selected_enemy_index].select()
	
func select_up():
	if(enemies.size() == 1):
		return
	
func select_down():
	if(enemies.size() == 1):
		return
		
func get_selected_enemy():
	return enemies[selected_enemy_index]

func get_selected_enemy_name():
	return enemies[selected_enemy_index].screen_name

