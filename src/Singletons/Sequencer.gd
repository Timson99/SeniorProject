extends Node

var in_control = false


var Events = EventSequences.get_data()

var active_event = null
var current_instruction = null
var last_actor_instruction_type = null


func _ready():
	pass
	
func assume_control():
	in_control = true
	InputEngine.disable_player_input()
	
func end_control():
	in_control = false
	InputEngine.enable_all()
	
	
func _process(_delta):
	if in_control and active_event == null:
		end_control()
	if active_event == null:
		return 
	elif !in_control and active_event != null:
		assume_control()
	
	var event = active_event
	if(event["current_instruction"] != null && event["current_instruction"].is_valid()):
		#print(event["current_instruction"].is_valid())
		return
		
	if event["instructions"].size() == 0:
		active_event = null
		return
		
	var instruction = event["instructions"].pop_front()
	if instruction.size() >= 2 && (instruction[0] in ["Actor-sync", "Actor-async", "Actor-call", "Actor-call-sync", "Actor-set"]):	
		event["current_instruction"] = funcref(self, "actor_instruction")
		event["current_instruction"].call_func(instruction)
	elif instruction.size() >= 2 && instruction[0] == "BG_Audio":
		event["current_instruction"] = funcref(self, "bg_audio_instruction")
		event["current_instruction"].call_func(instruction)
	elif instruction.size() == 2 && instruction[0] == "Dialogue":
		event["current_instruction"] = funcref(self, "dialogue_instruction")
		event["current_instruction"].call_func(instruction[1])
	elif instruction.size() == 3 && instruction[0] == "Scene":
		event["current_instruction"] = funcref(self, "scene_instruction")
		event["current_instruction"].call_func(instruction[1], instruction[2])
	elif instruction.size() == 2 && instruction[0] == "Battle":
		event["current_instruction"] = funcref(self, "battle_instruction")
		event["current_instruction"].call_func(instruction[1])
	elif instruction.size() >= 2 && instruction[0] == "Camera":
		instruction.pop_front()	
		event["current_instruction"] = funcref(self, "camera_instruction")
		event["current_instruction"].call_func(instruction)
	elif instruction.size() == 2 && instruction[0] == "Delay":
		event["current_instruction"] = funcref(self, "delay_instruction")
		event["current_instruction"].call_func(instruction[1])
	elif instruction.size() == 3 && instruction[0] == "Signal":		
		event["current_instruction"] = funcref(self, "signal_instruction")
		event["current_instruction"].call_func(instruction[1], instruction[2])
	else:
		Debugger.dprint("Error: Instruction Not Valid")
			

		

func execute_event(event_id : String):
	
	print(event_id)
	
	if not event_id in Events :
		Debugger.dprint("ERROR: Invalid Event")
		return
		
	if active_event != null:
		Debugger.dprint("ERROR: Event Alredy Running")
		return
	
	var event = load(Events[event_id])
	var instructions = event.instructions()
	active_event = {"event_id" : event_id, 
						  "instructions" : instructions,
						  "current_instruction" : null }
	
	
		
func actor_instruction(params: Array):
	var command_type = params[0]
	# If an instruction is called for an actor already executing a command,
	# the new instruction will NOT be processed by the Actor Engine until 
	# ALL asynchronous actions have finished.
	if ActorEngine.actors_dict[params[1]] in ActorEngine.asynchronous_actors_dict:
		if ActorEngine.asynchronous_delay_time > 0:
			yield(get_tree().create_timer(ActorEngine.asynchronous_delay_time, false), "timeout")
			ActorEngine.asynchronous_delay_time = 0.0
			
	# Note: params unpacked here to simplify code for process_command()
	if command_type == "Actor-set":
		if params.size() == 4:
			ActorEngine.set_command(params[1], params[2], params[3])
		else:
			Debugger.dprint("Invalid Arg count on following instruction: %s" % str(params))
			
	elif command_type == "Actor-call":
		if params.size() >= 3:
			ActorEngine.call_command(params[1], params[2], params.slice(3, params.size()))
		else:
			Debugger.dprint("Invalid Arg count on following instruction: %s" % str(params))
			
	elif command_type == "Actor-call-sync":
		if params.size() >= 3:
			ActorEngine.call_sync_command(params[1], params[2], params.slice(3, params.size()))
		else:
			Debugger.dprint("Invalid Arg count on following instruction: %s" % str(params))
	
	elif command_type == "Actor-async" || command_type == "Actor-sync":
		ActorEngine.async_or_sync_command(params)
		if command_type == "Actor-sync":
			yield(ActorEngine, "sync_command_complete")
		
	active_event["current_instruction"] = null
	return
	

func bg_audio_instruction(params: Array):
	if params.size() == 2:
		BgEngine.call_deferred(params[1])
	elif params.size() == 3:
		BgEngine.call_deferred(params[1], params[2])
	elif params.size() == 4:
		BgEngine.call_deferred(params[1], params[2], params[3])
	print(params)
	yield(BgEngine, "audio_finished")
	active_event["current_instruction"] = null
	return
	
	
# Open Dialogue, No Coroutine
func dialogue_instruction(dialogue_id : String):
	DialogueEngine._beginTransmit(dialogue_id, "")
	active_event["current_instruction"] = null
	return

#Begin Battle, No Coroutine, Last Instruction
func battle_instruction(scene_id : String):
	SceneManager.goto_scene(scene_id, "", true)
	yield(SceneManager, "scene_fully_loaded")
	active_event["current_instruction"] = null
	return

#Change Scene, No Coroutine, Last Instruction
func scene_instruction(scene_id : String, warp_id : String):
	SceneManager.goto_scene(scene_id, warp_id)
	#Runs next event after all onloads are called
	yield(SceneManager, "scene_loaded")
	active_event["current_instruction"] = null
	return
	
func camera_instruction(params : Array):
	if params[0] == "move_to_party":
		if params.size() == 2: 
			 CameraManager.move_to_party(params[1])
			 yield(CameraManager.tween, "tween_completed")	
			 CameraManager.release_camera() 
			 active_event["current_instruction"] = null
			 return
	if params[0] == "move_to_position":
		if params.size() == 3: 
			if CameraManager.grab_camera():
				CameraManager.move_to_position(params[1], params[2])
				yield(CameraManager.tween, "tween_completed")
			active_event["current_instruction"] = null
			return
	else:
		Debugger.dprint("Sequencer Error: Wrong Number of ARGS for " + params[0])
	active_event["current_instruction"] = null
		

func delay_instruction(time : float):
	yield(get_tree().create_timer(time, false), "timeout")
	active_event["current_instruction"] = null
	return

func signal_instruction(obj_id : String, signal_name):
	var object_to_observe = null
	var observed_objects = {
		#"Dialogue" : DialogueManager,
		"SceneManager" : SceneManager,
		"DialogueEngine" : DialogueEngine,
		"CameraManager" : CameraManager,
	}
	if obj_id in observed_objects.keys():
		object_to_observe = observed_objects[obj_id]
	elif obj_id in ActorEngine.actors_dict.keys():
		object_to_observe = ActorEngine.actors_dict[obj_id]

	yield(object_to_observe, signal_name)
	active_event["current_instruction"] = null
	return
