extends Resource

var enemy_types = {
	
	# Test enemies
	"SampleEnemy": {
		"enemy_scene_path": "res://Scenes/Enemy_Scenes/ExploreEnemies/SampleEnemy.tscn",
		'battle_sprite_scene': "res://Scenes/Enemy_Scenes/BattleEnemies/BattleEnemyDemo.tscn",
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
		"enemy_scene_path": "res://Scenes/Enemy_Scenes/ExploreEnemies/Area01/Bully.tscn",
		"battle_sprite_scene": "res://Scenes/Enemy_Scenes/BattleEnemies/Area01/BattleBully.tscn",
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
	"Boss1": {
		"enemy_scene_path": "res://Scenes/Enemy_Scenes/ExploreEnemies/Area01/Bully.tscn",
		"battle_sprite_scene": "res://Scenes/Enemy_Scenes/BattleEnemies/Area01/BattleBully.tscn",
		"battle_data": EntityStats.new({
										"LEVEL" : 1,
										"HP" : 15,
										"MAX_HP" : 15,
										"SP" : 15,
										"MAX_SP" : 15,
										"ATTACK" : 2,
										"DEFENSE" : 1,
										"WAVE_ATTACK" : 3,
										"WAVE_DEFENSE" : 2,
										"SPEED" : 3,
										"WILLPOWER" : 1,
										"LUCK" : 1,
									})
	}
}

