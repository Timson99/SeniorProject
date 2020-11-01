extends Control


export var alive := true

var selected = false

#Populated by Party
var stats := EntityStats.new()
var selected_material : ShaderMaterial
var party = null
var screen_name


var moveset = null

func _ready():
	pass # Replace with function body.
	
func on_load():
	var temp_battle_stats #= stats

# Called upon enemy's defeat
func deactivate_enemy():
	# Indicate enemy's defeat and remove sprite from party
	pass 
	
func select():
	$Sprite.set_material(selected_material)
	
func deselect():
	$Sprite.material = null
