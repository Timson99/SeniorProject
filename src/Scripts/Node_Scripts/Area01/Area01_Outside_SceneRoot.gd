extends ExploreRoot

var persistence_id = "Area01_Outside_Root"
var actor_id = "Area01_Outside_Root"

var event_trigger_scene = preload('res://Scenes/Explore_Scenes/Area01/BullyEventTrigger.tscn')
var event_trigger = null

onready var map = $TileMap
onready var houses = $YSort/Houses
onready var main_house = $YSort/MainHouse
onready var trees = $YSort/Trees
onready var bully = $YSort/BossBully
onready var world_body = $World_Collision
onready var tween = $Tween
onready var exit_door = $YSort/ExitDoor
onready var glow = $Glow


enum Attempt {One, Two, Three}
export var current_attempt = Attempt.One

var pre_fight = Vector2(-30,0)
var post_fight = Vector2(-250,0)

signal faded_out()

func _ready():
	add_to_group("Persistent")
	add_to_group("Actor")
	ActorEngine.update_actors()
	
func increment_attempt():
	current_attempt += 1
	current_attempt = min(current_attempt,Attempt.Three)

func _process(delta):
	if(Input.is_action_just_pressed("ui_test2")):
		execute_glow()
	if(Input.is_action_just_pressed("ui_test3")):
		vanish_world()

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
	
func fade_world():
	tween.interpolate_property(map, "modulate:a", null, 0.0, 1.0)
	tween.interpolate_property(trees, "modulate:a", null, 0.0, 1.0)
	tween.interpolate_property(main_house, "modulate:a", null, 0.0, 1.0)
	tween.interpolate_property(houses, "modulate:a", null, 0.0, 1.0)
	tween.interpolate_property(bully, "modulate:a", null, 0.0, 1.0)
	tween.start()
	yield(tween, "tween_all_completed")
	for collider in world_body.get_children():
		collider.disabled = true

func on_load():
	print(current_attempt)
	if current_attempt == Attempt.One:
		exit_door.hide()
		#create_vertical_event_trigger("Area01_Sequence02", pre_fight)
		create_vertical_event_trigger("Area01_Sequence03", post_fight)
	elif current_attempt == Attempt.Two:
		exit_door.hide()
		create_vertical_event_trigger("Area01_Sequence02", pre_fight)
		create_vertical_event_trigger("Area01_Sequence03", post_fight)
	elif current_attempt == Attempt.Three:
		exit_door.show()
		create_vertical_event_trigger("Area01_Sequence02", pre_fight)
		
func create_vertical_event_trigger(event_key, position):
	event_trigger = event_trigger_scene.instance()
	add_child(event_trigger)
	event_trigger.position = position
	event_trigger.event_key = event_key
		
		
func save():
	return {
		"persistence_id" : persistence_id,
		"current_attempt" : current_attempt,
	}


