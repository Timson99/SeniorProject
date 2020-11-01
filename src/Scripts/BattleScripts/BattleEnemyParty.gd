extends Control

export (Array, String) var enemies_debug_keys

onready var enemy_container = $HBoxContainer

var enemy_keys := []
var enemies := []
onready var battle_stats
onready var battle_scene

var selected_material = preload("res://Resources/Shaders/Illumination.tres")

func _ready():
	$HBoxContainer.rect_size = Vector2(0,0)
	var enemy_keys = EnemyHandler.queued_battle_enemies 
	

	if enemy_keys.size() == 0:
		enemy_keys = enemies_debug_keys

	for e in enemy_keys:
		var enemy_data = EnemyHandler.Enemies.enemy_types[e]
		battle_scene = load(enemy_data["battle_sprite_scene"]).instance()
		battle_stats = enemy_data["battle_data"]
		battle_scene.stats = battle_stats
		enemy_container.add_child(battle_scene)
	enemies = enemy_container.get_children()


func illuminate(isSelected):
	if isSelected:
		$Sprite.set_material(selected_material)
	elif $Sprite.material != null:
		$Sprite.material = null
