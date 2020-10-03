extends Node2D

var camera : Camera2D
onready var screen_size = get_viewport_rect().size

enum State {OnParty, Sequenced, Static}
var state = State.Static

func _ready():
	camera = Camera2D.new()
	add_child(camera)
	camera.current = true
	
	
#Run camera movement in physics process?
# Use signals for state changes rather than process constant checks
func _process(delta):
	var party = get_tree().get_nodes_in_group("Party")
	if party.size() != 1:
		if state != State.Static:
			state = State.Static
		position = Vector2(screen_size.x/2,screen_size.y/2)
		return
	if state != State.OnParty:
			state = State.OnParty
	var party_pos = party[0].active_player.get_global_position()
	position = Vector2(party_pos.x, party_pos.y)
	camera.align()
	#var viewport = get_viewport()
	#var vtransform = viewport.get_canvas_transform()
	#vtransform.origin += Vector2(0,1) 
	#get_viewport().set_canvas_transform(vtransform)
	#print(get_viewport().canvas_transform)

