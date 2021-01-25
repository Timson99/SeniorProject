extends Button

export var input_var = "M1"
var menu_v_position = 0
var menu_h_position = 0
var lr_movement = false



func _process(delta):
	#Import Menu options as a 2D array if necessary
	pass

func activate_menu():
	add_to_group("Input_Reciever")	

func deactivate_menu():
	remove_from_group("Input_Reciever")

func move_up():
	menu_v_position+=1
	
func move_down():
	menu_v_position -=1
	
func move_right():
	menu_h_position +=1
	
func move_left():
	menu_h_position -=1

