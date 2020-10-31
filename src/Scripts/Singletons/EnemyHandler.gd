extends Node

onready var Enemies = preload("res://Scripts/Resource_Scripts/EnemyTypes.gd").new()
onready var Tester = preload("res://Scenes/Enemy_Scenes/SpawningScenes/SpawnPositionTester.tscn").instance()

var random_num_generator = RandomNumberGenerator.new()

export var generated_enemy_id := 1
export var num_of_enemies := 0
export var max_enemies := 0	


onready var target_player: KinematicBody2D 
onready var player_view: Vector2
onready var current_scene = SceneManager.current_scene.name

onready var tilemap_rect: Rect2 
onready var tilemap_reference_point: Vector2
onready var tilemap_dimensions 
onready var tilemap_width: int
onready var tilemap_height: int 

onready var spawn_area: Area2D 
onready var spawn_collider: CollisionPolygon2D
#onready var spawn_area_vertices = spawn_collider.polygon

onready var scene_node: Node

var existing_enemy_data : Dictionary = {}
var queued_battle_enemies: Array = []
var queued_despawns : Array = []
var current_battle_stats : Dictionary
var can_spawn := true
var spawning_locked := false
var viewport_buffer := 40
var valid_pos_flag := false


func _ready():
	EnemyHandler.connect("scene_fully_loaded", self, "initialize_spawner_info")
	scene_node = SceneManager.current_scene
	#print(scene_node.name)
	if scene_node.get("enemies_spawnable") != null:
		can_spawn = scene_node.get("enemies_spawnable")
		if can_spawn:
			initialize_spawner_info()
	else: 
		can_spawn = false


func get_enemy_data(id: int):
	return existing_enemy_data.get(id)


func initialize_spawner_info():
	#print(can_spawn)
	scene_node = SceneManager.current_scene
	if can_spawn:
		#print("ENEMIES SPAWN")
		max_enemies = scene_node.get("max_enemies")
		#print(max_enemies)
		spawn_area = scene_node.get_node("EnemySpawnArea")
		spawn_collider = scene_node.get_node("EnemySpawnArea/SpawnAreaCollider")
		spawn_area.connect("body_entered", EnemyHandler, "set_valid_pos_flag")
		spawn_area.connect("body_exited", EnemyHandler, "reset_valid_pos_flag")
		tilemap_rect = scene_node.get_node("TileMap").get_used_rect()
		tilemap_reference_point = scene_node.get_node("TileMap").map_to_world(tilemap_rect.position)
		tilemap_dimensions = scene_node.get_node("TileMap").map_to_world(tilemap_rect.size)
		tilemap_width = tilemap_dimensions.x
		tilemap_height = tilemap_dimensions.y
	else:
		#print("ENEMIES CANNOT SPAWN")
		pass
	

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
		scene_node.add_child(new_enemy)
		generated_enemy_id += 1
		num_of_enemies += 1
		#print("Spawned enemy of id %d" % new_enemy.data_id)
	spawning_locked = false


func get_spawn_position():
	random_num_generator.randomize()
	var spawn_position_x = (tilemap_reference_point.x + random_num_generator.randi_range(0, tilemap_width)) #+ spawn_area_center.x
	var spawn_position_y = (tilemap_reference_point.x + random_num_generator.randi_range(0, tilemap_height)) #+ spawn_area_center.y
	print(Vector2(spawn_position_x, spawn_position_y))
	return Vector2(spawn_position_x, spawn_position_y)


func validate_enemy_spawn(possible_location: Vector2):
	Tester.position = possible_location
	scene_node.add_child(Tester)
	#print("TESTER INSTANCED")
	yield(get_tree().create_timer(1, false), "timeout")
	var valid_spawn_position = valid_pos_flag
	#print(valid_pos_flag)
	yield(get_tree().create_timer(1, false), "timeout")
	scene_node.remove_child(Tester)
	return valid_spawn_position
	
	
func set_valid_pos_flag(body: Node):
	#print("body entered: %s" % body.name)
	#print(body.get_global_position())
	if body.name == "Tester":
		valid_pos_flag = true
	
	
func reset_valid_pos_flag(body: Node):
	#print("body exited: %s" % body.name)
	if body.name == "Tester":
		valid_pos_flag = false	
	
	
func despawn_enemy(id: int):
	yield(SceneManager, "scene_fully_loaded")
	# despawning animation in the overworld
	can_spawn = true
	pass


func _physics_process(delta):
	var party := get_tree().get_nodes_in_group("Party")
	if current_scene != null && party.size() == 1:
		target_player = party[0].active_player
		player_view = CameraManager.viewport_size
		if can_spawn && num_of_enemies < max_enemies && !spawning_locked:
			spawn_enemy()
			#can_spawn = false
		if !can_spawn:
			pass
