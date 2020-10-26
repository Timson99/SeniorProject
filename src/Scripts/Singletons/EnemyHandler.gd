extends Node

const ENEMY = preload("res://Scenes/Enemy_Scenes/SampleEnemy.tscn")

export var generated_enemy_id := 1
export var num_of_enemies := 0
export var max_enemies := 5
var existing_enemy_data : Dictionary = {}
var queued_despawns : Array = []
var current_battle_stats : Dictionary
var can_spawn := true


func _ready():
	pass 

func get_enemy_data(id: int):
	return existing_enemy_data.get(id)
	
func spawn_enemy():
	var random_wait_time := randi()%7+12
	yield(get_tree().create_timer(random_wait_time, false), "timeout")
	var spawn_chance := randf()*0.0+1.0
	if spawn_chance > 0.5:
		var new_enemy = ENEMY.instance()
		new_enemy.data_id = generated_enemy_id
		new_enemy.position = Vector2(150, 150)
		var new_enemy_data = EntityStats.new({
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
		existing_enemy_data[new_enemy.data_id] = new_enemy_data.get_stats()
		get_tree().get_root().add_child(new_enemy)
		generated_enemy_id += 1
		print("single test enemy spawned")
	#pass
	
func despawn_enemy(id: int):
	yield(SceneManager, "scene_fully_loaded")
	# despawning animation in the overworld
	pass

func _physics_process(delta):
	if can_spawn && num_of_enemies < max_enemies:
		spawn_enemy()
		can_spawn = false
