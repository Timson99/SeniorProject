extends Object

class_name EnemyTypes



func get_data():
	return enemy_types

var enemy_types = {
	
	# Test enemies
	"SampleEnemy": {
		"enemy_scene_path": "res://Scenes/General/Enemies/ExploreEnemies/SampleEnemy.tscn",
		'battle_sprite_scene': "res://Scenes/General/Enemies/BattleEnemies/BattleEnemyDemo.tscn",
		"battle_data": EntityStats.new({
										"LEVEL" : 1,
										"HP" : 9,
										"MAX_HP" : 999,
										"SP" : 999,
										"MAX_SP" : 999,
										"ATTACK" : 1,
										"DEFENSE" : 1,
										"WAVE_ATTACK" : 1,
										"WAVE_DEFENSE" : 1,
										"SPEED" : 1,
										"WILLPOWER" : 69,
										"LUCK" : 420,
									})
	},
	"Bully": {
		"enemy_scene_path": "res://Scenes/Area01/Enemies/Bully/Bully.tscn",
		"battle_sprite_scene": "res://Scenes/Area01/Enemies/Bully/BattleBully.tscn",
		"battle_data": EntityStats.new({
										"LEVEL" : 1,
										"HP" : 10,
										"MAX_HP" : 10,
										"SP" : 20,
										"MAX_SP" : 20,
										"ATTACK" : 6,
										"DEFENSE" : 3,
										"WAVE_ATTACK" : 8,
										"WAVE_DEFENSE" : 5,
										"SPEED" : 5,
										"WILLPOWER" : 1,
										"LUCK" : 1,
									})
	},
} 

var bosses = {
	"Bully": {
		"enemy_scene_path": "res://Scenes/Area01/Enemies/Bully/BossBully.tscn",
		"battle_sprite_scene": "res://Scenes/Area01/Enemies/Bully/BattleBully.tscn",
		"battle_data": EntityStats.new({
										"LEVEL" : 1,
										"HP" : 10,
										"MAX_HP" : 10,
										"SP" : 20,
										"MAX_SP" : 20,
										"ATTACK" : 6,
										"DEFENSE" : 3,
										"WAVE_ATTACK" : 8,
										"WAVE_DEFENSE" : 5,
										"SPEED" : 5,
										"WILLPOWER" : 1,
										"LUCK" : 1,
									})
	},
}

