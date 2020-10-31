extends Resource

var enemy_types = {
	
	# Test enemies
	"SampleEnemy": {
		"enemy_scene_path": "res://Scenes/Enemy_Scenes/SampleEnemy.tscn",
		'battle_sprite': "res://Assets/Test_Art/icon.png",
		"battle_data": EntityStats.new({
										"LEVEL" : 1,
										"HP" : 999,
										"MAX HP" : 999,
										"SP" : 999,
										"MAX SP" : 999,
										"ATTACK" : 1,
										"DEFENSE" : 1,
										"WAVE ATTACK" : 1,
										"WAVE DEFENSE" : 1,
										"SPEED" : 1,
										"WILLPOWER" : 69,
										"LUCK" : 420,
									})
	},
	"Bully": {
		"enemy_scene_path": "res://Scenes/Enemy_Scenes/Bully.tscn",
		"battle_sprite": "res://Assets/Enemy_Art/Bully/Battle_Bully.png",
		"battle_data": EntityStats.new({
										"LEVEL" : 1,
										"HP" : 10,
										"MAX HP" : 10,
										"SP" : 20,
										"MAX SP" : 20,
										"ATTACK" : 6,
										"DEFENSE" : 3,
										"WAVE ATTACK" : 8,
										"WAVE DEFENSE" : 5,
										"SPEED" : 5,
										"WILLPOWER" : 1,
										"LUCK" : 1,
									})
	},
}
