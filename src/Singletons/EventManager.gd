extends Node

"""
	EventManager
		Used for creating Events
		
	Dependencies
		InputManager
		ActorManager
		SceneManager
		DialogueManager
		BackgroundAudio
		CameraManager
		EnemyHander?
		
"""

# Indicates if the EventManager is currently executing a event
var in_control = false


var Events = EventSequences.get_data()

var active_event = null
var current_instruction = null
var last_actor_instruction_type = null


func _ready():
	pass
	
func assume_control():
	in_control = true
	InputManager.disable(ActorManager.get_actor("Party").active_player.id)
	
func end_control():
	in_control = false
	InputManager.enable(ActorManager.get_actor("Party").active_player.id)
	
func execute_instructions(event):
	for instruction in event["instructions"]:
		
		var instruction_type = instruction[0]

		if instruction.size() >= 2 && (instruction_type == "Actor-sync" ):
			yield( actor_sync_instruction(instruction), "completed")
			
		elif instruction.size() >= 2 && (instruction_type in ["Actor-async", "Actor-call", "Actor-set"]  ):
			yield( actor_async_instruction(instruction), "completed")
			
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
		elif instruction.size() == 2 && instruction_type == "EnemyClear":
			yield( enemy_instruction(instruction[1]) , "completed")
		else:
			Debugger.dprint("Error: Instruction Not Valid")
	end_control()		
	

func execute_event(event_id : String):
	if not event_id in Events :
		Debugger.dprint("EventManager ERROR: Invalid Event id '%s'" % event_id)
		return
	if in_control == true:
		Debugger.dprint("EventManager ERROR: Event Already Running, can't run event_id '%s'" % event_id)
		return
	
	var event = load(Events[event_id])
	var instructions = event.instructions()
	active_event = {"event_id" : event_id, 
					"instructions" : instructions,
					"current_instruction" : null }
	assume_control()			
	yield(execute_instructions(active_event), "completed")
	end_control()
	

func actor_async_instruction(params: Array):
	yield(get_tree().create_timer(0, false), "timeout")
	var command_type = params[0]
	if command_type == "Actor-set":
		if params.size() == 4:
			ActorManager.set_command(params[1], params[2], params[3])
		else:
			Debugger.dprint("Invalid Arg count on following instruction: %s" % str(params))
			
	elif command_type == "Actor-call":
		if params.size() >= 3:
			ActorManager.call_command(params[1], params[2], params.slice(3, params.size()))
		else:
			Debugger.dprint("Invalid Arg count on following instruction: %s" % str(params))
	elif command_type == "Actor-async":
		if params.size() >= 3:
			ActorManager.async_command(params[1], params[2], params.slice(3, params.size()))
		else:
			Debugger.dprint("Invalid Arg count on following instruction: %s" % str(params))
			
			
func actor_sync_instruction(params: Array):
	yield(get_tree().create_timer(0, false), "timeout")
	var command_type = params[0]
	if command_type == "Actor-sync":
		if params.size() >= 3:
			yield(ActorManager.sync_command(params[1], params[2], params.slice(3, params.size())), "completed")
		else:
			Debugger.dprint("Invalid Arg count on following instruction: %s" % str(params))

	

func bg_audio_instruction(params: Array):
	yield(get_tree().create_timer(0, false), "timeout")
	if params.size() == 2:
		AudioManager.call_deferred(params[1])
	elif params.size() == 3:
		AudioManager.call_deferred(params[1], params[2])
	elif params.size() == 4:
		AudioManager.call_deferred(params[1], params[2], params[3])
	
	
# Open Dialogue, No Coroutine
func dialogue_instruction(dialogue_id : String):
	yield(get_tree().create_timer(0, false), "timeout")
	DialogueManager._beginTransmit(dialogue_id, "")

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
		"DialogueManager" : DialogueManager,
		"CameraManager" : CameraManager,
	}
	if obj_id in observed_objects.keys():
		object_to_observe = observed_objects[obj_id]
	elif ActorManager.actor_registry.has(obj_id):
		object_to_observe = ActorManager.actor_registry.fetch(obj_id)
	yield(object_to_observe, signal_name)
	
func enemy_instruction(empty_value):
	yield(get_tree().create_timer(0, false), "timeout")
	EnemyManager.call_deferred("clear_existing_enemy_data")
