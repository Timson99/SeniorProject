extends Sprite # May be changed to Control later in development

export var battle_id := 1

onready var battle_stats = EnemyHandler.get_enemy_data(battle_id)

func _ready():
	print(battle_stats)
	pass # Replace with function body.
