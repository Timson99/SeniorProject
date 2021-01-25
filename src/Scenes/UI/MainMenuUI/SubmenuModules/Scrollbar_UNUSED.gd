extends Node

var parent_ctnr = null

onready var scrollbar = $TextureRect/ItemList/Scrollbar
var sc_start =0
var scrollbar_size = 2
var scrollbar_offset = 0
var max_sc_offset = 92
var offset_size = max_sc_offset/5
# Called when the node enters the scene tree for the first time.
func _ready():
	_update_scrollbar()

func even(num):# can adjust condition to fit any number of columns
	return num%2 ==0
	
func _update_scrollbar():
	var middle = scrollbar.get_node("middle")
	sc_start = middle.get_position()
	scrollbar_offset = sc_start.y
	var prop_size = (float(len(parent_ctnr.buttons))/len(parent_ctnr.items))*max_sc_offset
	middle.set_scale(Vector2(1,prop_size/scrollbar_size))
	scrollbar_size = prop_size
	
	scrollbar.get_node("bottom").set_position(middle.get_position()+Vector2(0,scrollbar_size))
	var hidden_rows= ((len(parent_ctnr.items)-parent_ctnr.btn_ctnr_size)/parent_ctnr.num_cols)
	if parent_ctnr.num_cols>1 and not even(len(parent_ctnr.items)):
		hidden_rows +=1
	offset_size = float(max_sc_offset - scrollbar_size)/hidden_rows

func _move_scrollbar(direction):
	scrollbar_offset += offset_size if direction == "down" else -offset_size
	scrollbar.get_node("top").set_position(Vector2(sc_start.x,scrollbar_offset-1))
	scrollbar.get_node("middle").set_position(Vector2(sc_start.x,scrollbar_offset))
	scrollbar.get_node("bottom").set_position(Vector2(sc_start.x,scrollbar_offset+scrollbar_size))


	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
