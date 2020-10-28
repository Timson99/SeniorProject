extends Node

export var battle_id := 1
onready var battle_stats = EnemyHandler.get_enemy_data(battle_id)

func _ready():
	print(battle_stats)


