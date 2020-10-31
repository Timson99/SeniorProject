extends Control

export var battle_id := 1
onready var battle_stats = EnemyHandler.get_enemy_data(battle_id)
onready var enemies = EnemyHandler.queued_battle_enemies 

var selected_material = preload("res://Resources/Shaders/Illumination.tres")

func _ready():
	
	for e in enemies:
		var enemy_data = EnemyHandler.get_enemy_data(battle_id)
		print(enemy_data)
		var battle_stats = enemy_data.pop_front()
		print(battle_stats)
		# Ensure enemy has correct sprite & battle info
		#var sprite = Sprite.new()
		#sprite.texture = load(enemy_data.pop_front())
		#get_tree().get_root().get_node("Battle/BattleUI/EnemyParty").add_child(sprite)


func illuminate(isSelected):
	if isSelected:
		print("RAN")
		$Sprite.set_material(selected_material)
	elif $Sprite.material != null:
		$Sprite.material = null
