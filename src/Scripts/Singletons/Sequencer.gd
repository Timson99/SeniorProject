extends Node

var in_control = false


var Events = preload("res://Scripts/Resource_Scripts/EventSequences.gd").new()

var active_events = []
var current_instruction = null



func _ready():
	pass
	
func assume_control():
	in_control = true
	InputEngine.disable_player_input()
	print("Control Begun")
	
func end_control():
	in_control = false
	InputEngine.enable_all()
	print("Control Ended")
	
	
func _process(delta):
	if in_control and active_events.size() == 0:
		end_control()
	elif !in_control and active_events.size() > 0:
		assume_control()
		
	var indices_to_remove = []
		
	for i in range(active_events.size()):
		var event = active_events[i]
		if(event["current_instruction"] != null && event["current_instruction"].is_valid()):
			return
		if event["instructions"].size() == 0:
			indices_to_remove.append(i)
			break
		var instruction = event["instructions"].pop_front()
		if instruction.size() == 4 && instruction[0] == "AI":
			event["current_instruction"] = ai_instruction(instruction[1], instruction[2], instruction[3])
		elif instruction.size() == 2 && instruction[0] == "BG_Audio":
			event["current_instruction"] = bg_audio_instruction(instruction[1])
		elif instruction.size() == 2 && instruction[0] == "Dialogue":
			event["current_instruction"] = dialogue_instruction(instruction[1])
		elif instruction.size() == 3 && instruction[0] == "Scene":
			event["current_instruction"] = scene_instruction(instruction[1], instruction[2])
		elif instruction.size() == 2 && instruction[0] == "Battle":
			event["current_instruction"] = battle_instruction(instruction[1])
		elif instruction.size() >= 2 && instruction[0] == "Camera":
			instruction.pop_front()
			event["current_instruction"] = camera_instruction(instruction)
		elif instruction.size() == 2 && instruction[0] == "Delay":
			event["current_instruction"] = delay_instruction(instruction[1])
		elif instruction.size() == 3 && instruction[0] == "Signal":
			event["current_instruction"] = signal_instruction(instruction[1], instruction[2])
		else:
			Debugger.dprint("Error: Instruction Not Valid")
			
	for index in indices_to_remove:
		active_events.remove(index)
		

func execute_event(event_id : String):
	if not event_id in Events.sequences :
		Debugger.dprint("ERROR: Invalid Event")
		return
	
	var event = load(Events.sequences[event_id])
	var instructions = event.instructions()
	active_events.append({"event_id" : event_id, 
						  "instructions" : instructions,
						  "current_instruction" : null })
	
		
		
func ai_instruction(ai_id : String, command : String, time : float):
	print((ai_id + " " + command + " %d") % time)
	return
	
func bg_audio_instruction(audio_id : String):
	print(audio_id)
	return

func dialogue_instruction(dialogue_id : String):
	print(dialogue_id)
	return
	
func battle_instruction(scene_id : String):
	print(scene_id)
	return

func scene_instruction(scene_id : String, warp_id : String):
	print(scene_id + " " + warp_id)
	return
	
func camera_instruction(params : Array):
	if params[0] == "move_to_party":
		if params.size() == 2: 
			 var camera_move = CameraManager.move_to_party(params[1])
			 yield(CameraManager.tween, "tween_completed")	
			 CameraManager.release_camera() 
			 return
	if params[0] == "move_to_position":
		if params.size() == 3: 
			if CameraManager.grab_camera():
				CameraManager.move_to_position(params[1], params[2])
				yield(CameraManager.tween, "tween_completed")
			return
	else:
		Debugger.dprint("Sequencer Error: Wrong Number of ARGS for " + params[0])
		

func delay_instruction(time : float):
	yield(get_tree().create_timer(time, false), "timeout")
	return

func signal_instruction(obj_id : String, signal_name):
	var observed_objects = {
		#"Dialogue" : DialogueManager,
		"Scene" : SceneManager,
	}
	yield(observed_objects[obj_id], signal_name)
	return
