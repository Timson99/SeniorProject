extends Node

#Every Type of Enemy
onready var Enemies = preload("res://Scripts/Resource_Scripts/EnemyTypes.gd").new()

export var generated_enemy_id := 1
export var num_of_enemies := 0
export var max_enemies := 0	
export var enemy_variations := []

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
onready var scene_world_space = CameraManager.viewport.get_world_2d().direct_space_state

onready var scene_node: Node

var random_num_generator = RandomNumberGenerator.new()

var existing_enemy_data : Dictionary = {}
var queued_battle_enemies: Array = []
var queued_despawns : Array = []
var current_battle_stats : Dictionary
var can_spawn := true
var spawning_locked := false
var valid_pos_flag := false


func _ready():
	EnemyHandler.connect("scene_fully_loaded", self, "initialize_spawner_info")
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
	
# Needs continued balancing 
func spawn_enemy():
	spawning_locked = true
	random_num_generator.randomize()
	var random_wait_time: int = random_num_generator.randi_range(1, 3)
	yield(get_tree().create_timer(random_wait_time, false), "timeout")
	var spawn_chance: float = random_num_generator.randf_range(0, 1)
	
	var spawn_position = get_spawn_position()
	var within_view_x: bool = abs(spawn_position.x - target_player.position.x) < (player_view.x/2)
	var within_view_y: bool = abs(spawn_position.y - target_player.position.y) < (player_view.y/2)
	#print(spawn_position) 
	if spawn_chance > 0.2 && validate_spawn_position(spawn_position) && (!within_view_x && !within_view_y):
		var enemy_type: String = enemy_variations[random_num_generator.randi_range(0, 1)]
		var new_enemy = load(Enemies.enemy_types[enemy_type]["enemy_scene_path"]).instance()
		new_enemy.key = enemy_type
		new_enemy.data_id = generated_enemy_id
		new_enemy.position = spawn_position
		existing_enemy_data[new_enemy.data_id] = {}
		existing_enemy_data[new_enemy.data_id]["battle_data"] = Enemies.enemy_types[enemy_type]["battle_data"]
		scene_node.add_child(new_enemy)
		generated_enemy_id += 1
		num_of_enemies += 1
		print("Spawned enemy of id %d that is a %s" % [new_enemy.data_id, enemy_type])
	spawning_locked = false


func get_spawn_position():
	random_num_generator.randomize()
	var spawn_position_x = (tilemap_reference_point.x + random_num_generator.randi_range(0, tilemap_width)) #+ spawn_area_center.x
	var spawn_position_y = (tilemap_reference_point.x + random_num_generator.randi_range(0, tilemap_height)) #+ spawn_area_center.y
	return Vector2(spawn_position_x, spawn_position_y)


func validate_spawn_position(possible_location: Vector2):
	# .intersect_point() args: point, max_results, exclude, collision_layer, collide_with_bodies, collide_with_areas
	var area_interesections: Array = scene_world_space.intersect_point(possible_location, 32, [], 2147483647, false, true)
	var intersected_area_names := []
	for area in area_interesections: 
		intersected_area_names.append(area["collider"].name)
	return intersected_area_names.has("EnemySpawnArea")
	
	
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
