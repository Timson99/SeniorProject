extends Control

export var battle_id := 1

onready var enemies = EnemyHandler.queued_battle_enemies 
onready var battle_stats = EnemyHandler.queued_battle_enemies[0]["battle_data"] 
onready var battle_sprite

var selected_material = preload("res://Resources/Shaders/Illumination.tres")

func _ready():
	
	for e in enemies:
		battle_stats = e["battle_data"].get_stats()
		battle_sprite = load(e["battle_sprite"])
		# Ensure enemy has correct sprite & battle info
		#var sprite = Sprite.new()
		#sprite.texture = battle_sprite
		#get_tree().get_root().get_node("Battle/BattleUI/EnemyParty").add_child(sprite)


func illuminate(isSelected):
	if isSelected:
		print("RAN")
		$Sprite.set_material(selected_material)
	elif $Sprite.material != null:
		$Sprite.material = null
