extends Resource

class_name SoundEffects

const effects: Dictionary = {
	
	# General
	"OpenBox": null,
	
	# Area 01
	"EnterDoor01": "res://Assets/Audio/SFX/Demos/walk_transition_01.wav",

	}
	
static func get_sound(sound_sample):
	return effects[sound_sample]
