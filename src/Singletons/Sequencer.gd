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
	
func execute_instructions(event):
	yield(get_tree().create_timer(0, false), "timeout")
	for instruction in event["instructions"]:
		
		var instruction_type = instruction[0]

		if instruction.size() >= 2 && (instruction_type in ["Actor-async", "Actor-call", "Actor-set", "Actor-call-sync"]  ):
			yield( actor_instruction(instruction), "completed")
			
		elif instruction.size() >= 2 && instruction_type == "BG_Audio":
			yield( bg_audio_instruction(instruction) , "completed")
			
		elif instruction.size() == 2 && instruction_type == "Dialogue":
			yield( dialogue_instruction(instruction[1]) , "completed")
			
		elif instruction.size() == 3 && instruction_type == "Scene":
			yield( scene_instruction(instruction[1], instruction[2]) , "completed")
			
		elif instruction.size() == 2 && instruction_type == "Battle":
			yield( battle_instruction(instruction[1]) , "completed" )
			
		elif instruction.size() == 2 && instruction_type == "Delay":
			yield( delay_instruction(instruction[1]) , "completed")
			
		elif instruction.size() == 3 && instruction_type == "Signal":		
			yield( signal_instruction(instruction[1], instruction[2]) , "completed")
		else:
			Debugger.dprint("Error: Instruction Not Valid")
	end_control()		
	

func execute_event(event_id : String):
	if not event_id in Events :
		Debugger.dprint("ERROR: Invalid Event")
		return
		
	if in_control == true:
		Debugger.dprint("ERROR: Event Alredy Running")
		return
	
	var event = load(Events[event_id])
	var instructions = event.instructions()
	active_event = {"event_id" : event_id, 
						  "instructions" : instructions,
						  "current_instruction" : null }
	assume_control()			
	yield(execute_instructions(active_event), "completed")
	end_control()
	
		
func actor_instruction(params: Array):
	yield(get_tree().create_timer(0, false), "timeout")
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
			yield(ActorEngine.call_sync_command(params[1], params[2], params.slice(3, params.size())), "completed")
		else:
			Debugger.dprint("Invalid Arg count on following instruction: %s" % str(params))
	
	elif command_type == "Actor-async" || command_type == "Actor-sync":
		ActorEngine.async_or_sync_command(params)
		if command_type == "Actor-sync":
			yield(ActorEngine, "sync_command_complete")

	

func bg_audio_instruction(params: Array):
	yield(get_tree().create_timer(0, false), "timeout")
	if params.size() == 2:
		BgEngine.call_deferred(params[1])
	elif params.size() == 3:
		BgEngine.call_deferred(params[1], params[2])
	elif params.size() == 4:
		BgEngine.call_deferred(params[1], params[2], params[3])
	
	
# Open Dialogue, No Coroutine
func dialogue_instruction(dialogue_id : String):
	yield(get_tree().create_timer(0, false), "timeout")
	DialogueEngine._beginTransmit(dialogue_id, "")

#Begin Battle, No Coroutine, Last Instruction
func battle_instruction(scene_id : String):
	yield(get_tree().create_timer(0, false), "timeout")
	SceneManager.goto_scene(scene_id, "", true)
	yield(SceneManager, "scene_loaded")

#Change Scene, No Coroutine, Last Instruction
func scene_instruction(scene_id : String, warp_id : String):
	yield(get_tree().create_timer(0, false), "timeout")
	SceneManager.goto_scene(scene_id, warp_id)
	#Runs next event after all onloads are called
	yield(SceneManager, "scene_loaded")
		

func delay_instruction(time : float):
	yield(get_tree().create_timer(time, false), "timeout")

func signal_instruction(obj_id : String, signal_name):
	yield(get_tree().create_timer(0, false), "timeout")
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

