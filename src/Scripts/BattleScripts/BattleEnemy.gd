extends Sprite # May be changed to Control later in development

export var battle_id := 1
export var alive := true

func _ready():
	pass # Replace with function body.
	
func on_load():
	var temp_battle_stats #= stats

# Called upon enemy's defeat
func deactivate_enemy():
	pass 
