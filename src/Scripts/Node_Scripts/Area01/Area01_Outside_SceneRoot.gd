extends ExploreRoot


onready var map = $TileMap
onready var houses = $YSort/Houses
onready var main_house = $YSort/MainHouse
onready var trees = $YSort/Trees
onready var bully = $YSort/BossBully
onready var world_body = $World_Collision
onready var tween = $Tween
onready var exit_door = $YSort/ExitDoor

signal faded_out()


func _ready():
	pass

func _process(delta):
	if(Input.is_action_just_pressed("ui_test2")):
		tween.interpolate_property(map, "modulate:a", null, 0.0, 1.0)
		tween.interpolate_property(trees, "modulate:a", null, 0.0, 1.0)
		tween.interpolate_property(main_house, "modulate:a", null, 0.0, 1.0)
		tween.interpolate_property(houses, "modulate:a", null, 0.0, 1.0)
		tween.interpolate_property(bully, "modulate:a", null, 0.0, 1.0)
		tween.start()
		yield(tween, "tween_all_completed")
		for collider in world_body.get_children():
			collider.disabled = true
		print("Done")
		#self.visible = false
		
	


