 extends ExploreRoot

var persistence_id = "Area01_Data"
var actor_id = "Area01_Outside_Root"

var event_trigger_scene = preload('res://Scenes/Area01/Triggers/BullyEventTrigger.tscn')
var event_triggers := {}

onready var map = $TileMap
onready var houses = $YSort/Houses
onready var main_house = $YSort/MainHouse
onready var trees = $YSort/Trees
onready var bully = $YSort/BossBully
onready var world_body = $World_Collision
onready var tween = $Tween
onready var exit_door = $YSort/ExitDoor
onready var glow = $Glow


export var current_attempt = 1

var pre_fight = Vector2(64,0)
var first_post_fight = Vector2(-200,0)

signal faded_out()

func _ready():
	add_to_group("Persistent")
	ActorEngine.register_actor(self)



func increment_attempt():
	current_attempt += 1
	current_attempt = min(current_attempt,3)
	PersistentData.update_entry({"persistence_id" : "Area01_Closet","used" : false})

signal glow_complete()
func execute_glow():
	glow.show()
	glow.color.a = 1.0
	glow.color.b = 1.0
	glow.color.r = 0.0
	glow.color.g = 0.0
	tween.interpolate_property(glow, "color:r", 0.0, 0.5, 2.0)
	tween.interpolate_property(glow, "color:b", 1.0, 0.25, 2.0)
	tween.interpolate_property(glow, "color:g", 0.0, 1.0, 2.0)
	#tween.interpolate_property(glow, "color:a", 0.0, 1.0, 1.0)
	tween.start()
	fade_world()
	yield(get_tree().create_timer(1.0, false), "timeout")
	tween.interpolate_property(glow, "color:a", 1.0, 0.0, 1.0)
	yield(tween, "tween_all_completed")
	glow.hide()
	emit_signal("glow_complete")
		
func vanish_world():
	map.hide()
	trees.hide()
	main_house.hide()
	houses.hide()
	bully.hide()
	for collider in world_body.get_children():
		collider.disabled = true
	
func fade_world(fade_time = 1.0):
	tween.interpolate_property(map, "modulate:a", null, 0.0, fade_time)
	tween.interpolate_property(trees, "modulate:a", null, 0.0, fade_time)
	tween.interpolate_property(main_house, "modulate:a", null, 0.0, fade_time)
	tween.interpolate_property(houses, "modulate:a", null, 0.0, fade_time)
	tween.interpolate_property(bully, "modulate:a", null, 0.0, fade_time)
	tween.start()
	yield(tween, "tween_all_completed")
	for collider in world_body.get_children():
		collider.disabled = true

func on_load():
	bully.reload()
	if current_attempt == 1:
		exit_door.hide()
		if bully.attempt_one_alive == true:
			create_vertical_event_trigger("Area01_Sequence02", pre_fight, "pre_fight")
		create_vertical_event_trigger("Area01_Sequence03", first_post_fight, "first_post_fight")
	elif current_attempt == 2:
		exit_door.show()
		if bully.attempt_two_alive == true:
			create_vertical_event_trigger("Area01_Sequence02", pre_fight, "pre_fight")
		#create_vertical_event_trigger("Area01_Sequence05", first_post_fight, "first_post_fight")
	elif current_attempt == 3:
		exit_door.show()
		create_vertical_event_trigger("Area01_Sequence06", pre_fight, "pre_fight")
		
func create_vertical_event_trigger(event_key, position, id):
	var event_trigger = event_trigger_scene.instance()
	add_child(event_trigger)
	event_trigger.position = position
	event_trigger.event_key = event_key
	event_triggers[id] = event_trigger
	
func remove_vertical_event_trigger(id):
	var event_trigger = event_triggers[id]
	event_triggers.erase(id)
	event_trigger.queue_free()
		
		
func save():
	return {
		"persistence_id" : persistence_id,
		"current_attempt" : current_attempt,
	}


