extends Resource

class_name SoundEffects

const effects: Dictionary = {
	
	# General
	"OpenBox": "res://Assets/Audio/SFX/General/open_chest.wav",
	"ItemJingle": "res://Assets/Audio/SFX/General/get_item.wav",
	"OpenMenu": null,
	"CloseMenu": null,
	"MenuButtonSelect": null,
	"MenuButtonReturn": null,
	
	
	# Area 01
	"EnterDoor01": "res://Assets/Audio/SFX/Area01/walk_transition_01.wav",
	"PutOnCoat01": "res://Assets/Audio/SFX/Area01/coat01.wav",
	"PickUpPaper01": "res://Assets/Audio/SFX/Area01/paper01.wav",
	"SimulationGlow01": null,
	"Falling01": "res://Assets/Audio/SFX/Area01/falling01.wav",
	"HitBed01": "res://Assets/Audio/SFX/Area01/bed_hit01.wav",
	"HitBed02": "res://Assets/Audio/SFX/Area01/bed_hit02.wav",
	"Falling02": "res://Assets/Audio/SFX/Area01/falling02.wav",
	"MetalDoorSlam01": "res://Assets/Audio/SFX/Area01/metal_door_slam.wav"

	}
	
static func get_sound(sound_sample):
	return effects[sound_sample]
