extends Node

#Every Type of Enemy
onready var Enemies = EnemyTypes.get_data()

onready var spawn_body = preload("res://Scenes/General/Enemies/SpawningScenes/SpawnPositionTester.tscn").instance()

var random_num_generator = RandomNumberGenerator.new()

export var generated_enemy_id := 1
export var num_of_enemies := 0
export var max_enemies := 0	
export var enemy_variations := []

onready var target_player: KinematicBody2D 
onready var player_view: Vector2

onready var tilemap_rect: Rect2 
onready var tilemap_reference_point: Vector2
onready var tilemap_dimensions 
onready var tilemap_width: int
onready var tilemap_height: int 

onready var spawn_area: Area2D 
onready var spawn_collider: CollisionPolygon2D
onready var scene_world_space = CameraManager.viewport.get_world_2d().direct_space_state

onready var scene_node: Node

var existing_enemy_data : Dictionary = {}
var queued_battle_enemies: Array = []
var current_battle_stats : Dictionary
var can_spawn := true
var spawning_locked := false
var valid_pos_flag := false


func clear():
	queued_battle_enemies = []

func _ready():
	SceneManager.connect("goto_called", self, "block_spawning")
	SceneManager.connect("scene_fully_loaded", self, "check_if_spawning_possible")
	check_if_spawning_possible()


func block_spawning():
	can_spawn = false

	
func check_if_spawning_possible():
	scene_node = SceneManager.current_scene
	if scene_node.get("enemies_spawnable") != null:
		can_spawn = scene_node.get("enemies_spawnable")
		if can_spawn:
			initialize_spawner_info()
	else: 
		can_spawn = false


func get_enemy_data(id: int):
	return existing_enemy_data.get(id)


func initialize_spawner_info():
	scene_node = SceneManager.current_scene
	if can_spawn:
		max_enemies = scene_node.get("max_enemies")
		enemy_variations = scene_node.get("enemy_variations")
		spawn_area = scene_node.get_node("EnemySpawnArea")
		spawn_collider = scene_node.get_node("EnemySpawnArea/SpawnAreaCollider")
		spawn_area.connect("body_entered", EnemyHandler, "set_valid_pos_flag")
		spawn_area.connect("body_exited", EnemyHandler, "reset_valid_pos_flag")
		tilemap_rect = scene_node.get_node("TileMap").get_used_rect()
		tilemap_reference_point = scene_node.get_node("TileMap").map_to_world(tilemap_rect.position)
		tilemap_dimensions = scene_node.get_node("TileMap").map_to_world(tilemap_rect.size)
		tilemap_width = tilemap_dimensions.x
		tilemap_height = tilemap_dimensions.y


func add_enemy_data(id, enemy_obj):
	existing_enemy_data[id] = {}
	existing_enemy_data[id]["body"] = enemy_obj
	
	
func initialize_enemy_instance(id: int, enemy_type: String, spawn_position: Vector2):
	var new_enemy = load(Enemies[enemy_type]["enemy_scene_path"]).instance()
	existing_enemy_data[id] = {}
	existing_enemy_data[id]
	new_enemy.key = enemy_type
	new_enemy.data_id = id
	new_enemy.position = spawn_position
	existing_enemy_data[id]["position"] = spawn_position
	existing_enemy_data[id]["type"] = enemy_type
	existing_enemy_data[id]["body"] = new_enemy
	return new_enemy

	
# Needs continued balancing 
func spawn_enemy():
	spawning_locked = true
	random_num_generator.randomize()
	var random_wait_time: int = random_num_generator.randi_range(1, 3)
	var spawn_chance: float = random_num_generator.randf_range(0, 1)
	var spawn_position = get_spawn_position()
	var view_buffer: int = 20
	var within_view_x: bool = abs(spawn_position.x - target_player.position.x) < (player_view.x/2 + view_buffer)
	var within_view_y: bool = abs(spawn_position.y - target_player.position.y) < (player_view.y/2 + view_buffer)
	if spawn_chance > 0.5 && validate_spawn_position(spawn_position) && (!within_view_x && !within_view_y):
		var enemy_type: String = enemy_variations[random_num_generator.randi_range(0, enemy_variations.size()-1)]
		var new_enemy = initialize_enemy_instance(generated_enemy_id, enemy_type, spawn_position)
		scene_node.add_child(new_enemy)
		generated_enemy_id += 1
		num_of_enemies += 1
		print("New enemy added")
	spawning_locked = false


func get_spawn_position():
	random_num_generator.randomize()
	var spawn_position_x = (tilemap_reference_point.x + random_num_generator.randi_range(0, tilemap_width)) 
	var spawn_position_y = (tilemap_reference_point.x + random_num_generator.randi_range(0, tilemap_height)) 
	return Vector2(spawn_position_x, spawn_position_y)


func validate_spawn_position(possible_location: Vector2):
	# .intersect_point() args: point, max_results, exclude, collision_layer, collide_with_bodies, collide_with_areas
	var area_interesections: Array = scene_world_space.intersect_point(possible_location, 32, [], 2147483647, false, true)
	var intersected_area_names := []
	for area in area_interesections: 
		intersected_area_names.append(area["collider"].name)
	if intersected_area_names.has("DetectionRadius"):
		return false
	return intersected_area_names.has("EnemySpawnArea")
	
	
func freeze_on_contact():
	get_tree().call_group("Enemy", "freeze_in_place")

#called if goto_saved is used
func despawn_on():
	SceneManager.connect("scene_loaded", self, "despawn_defeated_enemies")
func despawn_off():
	SceneManager.disconnect("scene_loaded", self, "despawn_defeated_enemies")
	
# Called for battle victory or fleeing
func despawn_defeated_enemies():
	for enemy in queued_battle_enemies:
			existing_enemy_data[enemy]["body"].post_battle()
			existing_enemy_data.erase(enemy)
			#scene_node.remove_child(existing_enemy_data[enemy]["exploration_node"])
	# 2. handling the despawn of multiple enemies who joined in a gang
	num_of_enemies -= 1
	can_spawn = true
	clear()
	despawn_off()


func _physics_process(delta):
	var party := get_tree().get_nodes_in_group("Party")
	if scene_node != null && party.size() == 1:
		target_player = party[0].active_player
		player_view = CameraManager.viewport_size
		if can_spawn && num_of_enemies < max_enemies && !spawning_locked:			
			spawn_enemy()
