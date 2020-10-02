extends Node

var in_control = false


var Events = preload("res://Scripts/Resource_Scripts/EventSequences.gd").new()

var active_events = []
var current_instruction = null



func _ready():
	pass
	
func assume_control():
	in_control = true
	print("Control Begun")
	
func end_control():
	in_control = false
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
		elif instruction.size() == 3 && instruction[0] == "Camera":
			event["current_instruction"] = camera_instruction(instruction[1], instruction[2])
		elif instruction.size() == 2 && instruction[0] == "Delay":
			event["current_instruction"] = delay_instruction(instruction[1])
		elif instruction.size() == 3 && instruction[0] == "Yield":
			event["current_instruction"] = yield_instruction(instruction[1], instruction[2])
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
	
func camera_instruction(command : String, time : float):
	print((command + " %d") % time)
	return

func delay_instruction(time : float):
	yield(get_tree().create_timer(time, false), "timeout")
	return

func yield_instruction(obj_id : String, signal_name):
	var observed_objects = {
		#"Dialogue" : DialogueManager,
		"Scene" : SceneManager,
	}
	yield(observed_objects[obj_id], signal_name)
	return
