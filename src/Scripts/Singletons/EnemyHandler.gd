extends Node

# Resource script with all possible enemy instantiations?
onready var Enemies = preload("res://Scripts/Resource_Scripts/EnemyTypes.gd").new()

var random_num_generator = RandomNumberGenerator.new()

export var generated_enemy_id := 1
export var num_of_enemies := 0
export var max_enemies := 5
var existing_enemy_data : Dictionary = {}
var queued_despawns : Array = []
var current_battle_stats : Dictionary
var can_spawn := true # Will be determined by the SceneManager later on


func _ready():
	pass 

func get_enemy_data(id: int):
	return existing_enemy_data.get(id)
	
func spawn_enemy():
	random_num_generator.randomize()
	var random_wait_time: int = random_num_generator.randi_range(2, 5)
	print(random_wait_time)
	yield(get_tree().create_timer(random_wait_time, false), "timeout")
	var spawn_chance: float = random_num_generator.randf_range(0.5, 1)			# CHANGE LATER TO 0, 1
	print(spawn_chance)
	if spawn_chance > 0.5:
		var new_enemy = load(Enemies.enemy_types["SampleEnemy"]["enemy_scene_path"]).instance()
		new_enemy.data_id = generated_enemy_id
		new_enemy.position = Vector2(150, 150)
		var new_enemy_data = Enemies.enemy_types["SampleEnemy"]["battle_data"]
		existing_enemy_data[new_enemy.data_id] = new_enemy_data.get_stats()
		get_tree().get_root().add_child(new_enemy)
		generated_enemy_id += 1
		print("single test enemy spawned")
	
	
func despawn_enemy(id: int):
	yield(SceneManager, "scene_fully_loaded")
	# despawning animation in the overworld
	pass


func _physics_process(delta):
	if can_spawn && num_of_enemies < max_enemies:
		spawn_enemy()
		can_spawn = false
