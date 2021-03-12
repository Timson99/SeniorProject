extends Object

class_name EnemyTypes



static func get_data():
	return enemy_types

const enemy_types = {
	
	# Test enemies
	"SampleEnemy": {
		"enemy_scene_path": "res://Scenes/Area01/Enemies/SampleEnemy/SampleEnemy.tscn",
		'battle_sprite_scene': "res://Scenes/Area01/Enemies/SampleEnemy/BattleEnemyDemo.tscn",
		"ai" : "res://Scenes/Area01/Enemies/SampleEnemy/SampleEnemy_ai.gd",
	},
	
	# Area02 enemies
	"FoxEnemy": {
		"enemy_scene_path": "res://Scenes/Area02/Enemies/Fox/Fox.tscn",
		"battle_sprite_scene": "res://Scenes/Area02/Enemies/Fox/BattleFox.tscn",
		"ai": "res://Scenes/Area02/Enemies/Fox/Fox_ai.gd"
	},
		

##~~~~~~~~~~~~~~~~Bosses~~~~~~~~~~~~~~~~~~~

	"Bully": {
		"enemy_scene_path": "res://Scenes/Area01/Enemies/Bully/Bully.tscn",
		"battle_sprite_scene": "res://Scenes/Area01/Enemies/Bully/BattleBully.tscn",
		"ai": "res://Scenes/Area01/Enemies/Bully/Bully_ai.gd"
	},
}

