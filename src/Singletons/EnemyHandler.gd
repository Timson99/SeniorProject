extends Node

onready var Enemies = EnemyTypes.get_data()

signal spawn_func_completed

var random_num_generator = RandomNumberGenerator.new()

export var generated_enemy_id := 1
export var num_of_enemies := 0
export var max_enemies := 0	
export var enemy_variations := []

onready var target_player: KinematicBody2D 
onready var player_view: Vector2

onready var scene_node: Node
onready var spawn_locations := []
onready var spawner_balancer := {}


var existing_enemy_data : Dictionary = {}
var queued_battle_enemies: Array = []
var queued_battle_ids: Array = []
var can_spawn := true
var spawning_launched := false
var spawning_locked := false
var enemy_spawner_ratio: float



func _ready():
	SceneManager.connect("goto_called", self, "block_spawning")
	SceneManager.connect("scene_fully_loaded", self, "check_if_spawning_possible")
	check_if_spawning_possible()


# Called whenever a new scene is loaded; checks if explore root of the 
# new scene permits enemy spawning (i.e. in exploration mode).	
func check_if_spawning_possible():
	scene_node = SceneManager.current_scene
	if scene_node.get("enemies_spawnable") != null:
		can_spawn = scene_node.get("enemies_spawnable")
		if can_spawn:
			initialize_spawner_info()
	else: 
		block_spawning()


# If enemies can be spawned, information about where enemies can spawn is
# gathered from the children nodes of the current explore scene.
func initialize_spawner_info():
	scene_node = SceneManager.current_scene
	if can_spawn:
		max_enemies = scene_node.get("max_enemies")
		enemy_variations = scene_node.get("enemy_variations")
		spawn_locations = get_tree().get_nodes_in_group("SpawnLocation")
		enemy_spawner_ratio = float(max_enemies) / spawn_locations.size()
		for spawn_location_id in range(spawn_locations.size()):
			spawner_balancer[spawn_location_id] = 0


func block_spawning():
	can_spawn = false
	

func enable_spawning():
	can_spawn = true


func spawn_enemy():
	spawning_locked = true
	random_num_generator.randomize()
	var spawn_position = get_spawn_position() 
	if spawn_position != null:
			var enemy_type: String = enemy_variations[random_num_generator.randi_range(0, enemy_variations.size()-1)]
			var new_enemy = create_enemy_instance(generated_enemy_id, enemy_type, spawn_position)
			scene_node.add_child(new_enemy)
			generated_enemy_id += 1
			num_of_enemies += 1
			print("New enemy added")
			print(spawner_balancer)
	spawning_locked = false
	return 
	

func get_spawn_position():
	random_num_generator.randomize()
	var chosen_location: int = random_num_generator.randi_range(0, spawn_locations.size()-1)
	var spawn_position: Vector2 = spawn_locations[chosen_location].position
	var player_view_buffer: int = 60
	var within_view_x: bool = abs(spawn_position.x - target_player.position.x) < (player_view.x/2 + player_view_buffer)
	var within_view_y: bool = abs(spawn_position.y - target_player.position.y) < (player_view.y/2 + player_view_buffer)
	if (!within_view_x && !within_view_y) && (spawner_balancer[chosen_location] < enemy_spawner_ratio):
		spawner_balancer[chosen_location] += 1
		print(spawn_locations[chosen_location].position)
		return spawn_locations[chosen_location].position
	else:
		return null


func create_enemy_instance(id: int, enemy_type: String, spawn_position: Vector2):
	var new_enemy = load(Enemies[enemy_type]["enemy_scene_path"]).instance()
	add_enemy_data(id, new_enemy)
	existing_enemy_data[id]["position"] = spawn_position
	existing_enemy_data[id]["type"] = enemy_type
	new_enemy.key = enemy_type
	new_enemy.data_id = id
	new_enemy.position = spawn_position
	return new_enemy
	
	
func add_enemy_data(id, enemy_obj):
	existing_enemy_data[id] = {}
	existing_enemy_data[id]["body"] = enemy_obj
	
	
func get_enemy_data(id: int):
	return existing_enemy_data.get(id)	
	
	
func add_to_battle_queue(enemy_type: String):
	queued_battle_enemies.append(enemy_type)
	

func collect_battle_enemy_ids(id: int):
	queued_battle_ids.append(id)	
	
	
# Non-boss enemies are not persistent; existing enemies must be preserved 
# whenever the player engages in a battle.	
func retain_enemy_data():
	for enemy in existing_enemy_data:
		existing_enemy_data[enemy]["position"] = existing_enemy_data[enemy]["body"].position
	block_spawning()


func freeze_all_enemies():
	get_tree().call_group("Enemy", "freeze_in_place")


# After a battle concludes, all enemies are returned to the overworld in their
# pre-battle positions. Defeated enemies are deleted after playing death animations.
func readd_previously_instanced_enemies():
	scene_node = SceneManager.current_scene
	for enemy_id in existing_enemy_data:
		var enemy_type = (existing_enemy_data[enemy_id]["type"])
		var saved_position = existing_enemy_data[enemy_id]["position"]
		var readded_enemy = create_enemy_instance(enemy_id, enemy_type, saved_position)
		if enemy_id in queued_battle_ids:
			readded_enemy.alive = false
			readded_enemy.get_node("CollisionBox").disabled = true
			readded_enemy.get_node("DetectionRadius").queue_free()
		scene_node.add_child(readded_enemy)
	yield(SceneManager, "scene_fully_loaded")
	
	

# Called if goto_saved is used
func despawn_on():
	SceneManager.connect("scene_loaded", self, "despawn_defeated_enemies")
func despawn_off():
	SceneManager.disconnect("scene_loaded", self, "despawn_defeated_enemies")
	
	
func clear_queued_enemies():
	queued_battle_enemies = []	
	queued_battle_ids = []
	
	
# Called for battle victory or fleeing
func despawn_defeated_enemies():
	readd_previously_instanced_enemies()
	for enemy_id in queued_battle_ids:
		existing_enemy_data[enemy_id]["body"].post_battle()
		scene_node.remove_child(existing_enemy_data[enemy_id]["body"])
		existing_enemy_data.erase(enemy_id)
		num_of_enemies -= 1
	# 2. handling the despawn of multiple enemies who joined in a gang
	clear_queued_enemies()
	despawn_off()
	enable_spawning()


func _physics_process(delta):
	var party := get_tree().get_nodes_in_group("Party")
	if scene_node != null && party.size() == 1:
		target_player = party[0].active_player
		player_view = CameraManager.viewport_size
		if !spawning_launched:
			spawning_launched = !spawning_launched
			launch_spawning_loop()
		
			
# If enemies can be spawned and the target player character has been located,
# loops indefinitely to spawn a balanced distribution of enemies in overworld.
func launch_spawning_loop():
	while can_spawn:
		var random_wait_time: int = random_num_generator.randf_range(0, 1)
		yield(get_tree().create_timer(random_wait_time, false), "timeout")
		if !spawning_locked && num_of_enemies < max_enemies:
			spawn_enemy()
			


