extends Node

# Resource script with all possible enemy instantiations?
onready var Scenes = preload("res://Scripts/Resource_Scripts/MainScenes.gd")
onready var Enemies = preload("res://Scripts/Resource_Scripts/EnemyTypes.gd").new()
onready var Tester = preload("res://Scenes/Enemy_Scenes/SpawningScenes/SpawnPositionTester.tscn").instance()

var random_num_generator = RandomNumberGenerator.new()

export var generated_enemy_id := 1
export var num_of_enemies := 0
export var max_enemies := 3


onready var target_player 
onready var player_view 
onready var current_scene = SceneManager.current_scene.filename

onready var tilemap_rect: Rect2 = get_tree().get_root().get_node("Node2D/TileMap").get_used_rect()
onready var tilemap_reference_point = get_tree().get_root().get_node("Node2D/TileMap").map_to_world(tilemap_rect.position)
onready var tilemap_dimensions = get_tree().get_root().get_node("Node2D/TileMap").map_to_world(tilemap_rect.size)
onready var tilemap_width: int = tilemap_dimensions.x
onready var tilemap_height: int = tilemap_dimensions.y

onready var spawn_area = get_tree().get_root().get_node("Node2D").get_node("EnemySpawnArea")
onready var spawn_collider = get_tree().get_root().get_node("Node2D").get_node("EnemySpawnArea/SpawnAreaCollider")
onready var spawn_area_vertices = spawn_collider.polygon
#onready var spawn_area_center = spawn_area.position + spawn_collider.position

var existing_enemy_data : Dictionary = {}
var queued_battle_enemies: Array = []
var queued_despawns : Array = []
var current_battle_stats : Dictionary
var can_spawn := true # Will be determined by the SceneManager later on
var spawning_locked := false
var viewport_buffer := 40
var valid_pos_flag := false


func _ready():
	spawn_area.connect("body_entered", EnemyHandler, "set_valid_pos_flag")
	spawn_area.connect("body_exited", EnemyHandler, "reset_valid_pos_flag")
	pass 


func get_enemy_data(id: int):
	return existing_enemy_data.get(id)
	
	
# Currently drops frames on Joe's laptop when instancing new enemy object 
func spawn_enemy():
	spawning_locked = true
	random_num_generator.randomize()
	var random_wait_time: int = random_num_generator.randi_range(2, 5)
	yield(get_tree().create_timer(random_wait_time, false), "timeout")
	var spawn_chance: float = random_num_generator.randf_range(0, 1)
	
	var spawn_position = get_spawn_position()
	var within_view_x: bool = abs(spawn_position.x - target_player.position.x) < (player_view.x/2 + viewport_buffer)
	var within_view_y: bool = abs(spawn_position.y - target_player.position.y) < (player_view.y/2 + viewport_buffer)
	
	if spawn_chance > 0.2 && validate_enemy_spawn(spawn_position) && (!within_view_x && !within_view_y):
		var new_enemy = load(Enemies.enemy_types["Bully"]["enemy_scene_path"]).instance()
		new_enemy.data_id = generated_enemy_id
		new_enemy.position = spawn_position
		var new_enemy_data = Enemies.enemy_types["Bully"]["battle_data"]
		var enemy_battle_sprite = Enemies.enemy_types["Bully"]["battle_sprite"]
		existing_enemy_data[new_enemy.data_id] = [new_enemy_data.get_stats(), enemy_battle_sprite]
		get_tree().get_root().get_node("Node2D").add_child(new_enemy)
		generated_enemy_id += 1
		num_of_enemies += 1
		print("Spawned enemy of id %d" % new_enemy.data_id)
	spawning_locked = false


func get_spawn_position():
	random_num_generator.randomize()
	var spawn_position_x = (tilemap_reference_point.x + random_num_generator.randi_range(0, tilemap_width)) #+ spawn_area_center.x
	var spawn_position_y = (tilemap_reference_point.x + random_num_generator.randi_range(0, tilemap_height)) #+ spawn_area_center.y
	print(Vector2(spawn_position_x, spawn_position_y))
	return Vector2(spawn_position_x, spawn_position_y)


func validate_enemy_spawn(possible_location: Vector2):
	Tester.position = possible_location
	get_tree().get_root().get_node("Node2D").add_child(Tester)
	print("TESTER INSTANCED")
	yield(get_tree().create_timer(1, false), "timeout")
	var valid_spawn_position = valid_pos_flag
	print(valid_pos_flag)
	yield(get_tree().create_timer(1, false), "timeout")
	get_tree().get_root().get_node("Node2D").remove_child(Tester)
	return valid_spawn_position
	
	
func set_valid_pos_flag(body: Node):
	print("body entered: %s" % body.name)
	#print(body.get_global_position())
	if body.name == "Tester":
		valid_pos_flag = true
	
	
func reset_valid_pos_flag(body: Node):
	print("body exited: %s" % body.name)
	if body.name == "Tester":
		valid_pos_flag = false	
	
func despawn_enemy(id: int):
	yield(SceneManager, "scene_fully_loaded")
	# despawning animation in the overworld
	can_spawn = true
	pass


func _physics_process(delta):
	if current_scene != null:
		target_player = get_tree().get_nodes_in_group("Party")[0].active_player # NOT IDEAL TO CHECK IN PHYSICS PROCESS??
		player_view = CameraManager.viewport_size
		if can_spawn && num_of_enemies < max_enemies && !spawning_locked:
			spawn_enemy()
			#can_spawn = false
		if !can_spawn:
			print("CANNOT SPAWN")
