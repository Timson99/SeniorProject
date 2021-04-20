extends Resource

class_name SoundEffects

const effects: Dictionary = {
	
	# General
	"OpenBox": "res://Assets/Audio/SFX/General/open_chest.wav",
	"ItemJingle": "res://Assets/Audio/SFX/General/get_item.wav",
	
	# Menus
	"OpenMenu": "res://Assets/Audio/SFX/General/Menus/menu_open_1.wav",
	"CloseMenu": "res://Assets/Audio/SFX/General/Menus/menu_close_1.wav",
	"MenuButtonSelect": "res://Assets/Audio/SFX/General/Menus/menu_confirm_1.wav",
	"MenuButtonReturn": "res://Assets/Audio/SFX/General/Menus/menu_back_1.wav",
	"MenuButtonSwitchFocus": "res://Assets/Audio/SFX/General/Menus/menu_switch_focus.wav",
	
	# Battles
	"BattleMenuSwitchFocus": "res://Assets/Audio/SFX/General/Battle/battle_menu_switch_focus.wav",
	"BattleMenuButtonSelect": "res://Assets/Audio/SFX/General/Battle/battle_menu_confirm.wav",
	"BattleMenuButtonReturn": "res://Assets/Audio/SFX/General/Battle/battle_menu_back.wav",
	#Could add varying sounds for battle; just have baseline here
	"BasicPlayerAttack1": "res://Assets/Audio/SFX/General/Battle/battle_basic_party_attack.wav",
	"BasicPlayerTakeDamage1": "res://Assets/Audio/SFX/General/Battle/battle_basic_party_take_damge.wav",
	"BasicPlayerFleeing": "res://Assets/Audio/SFX/General/Battle/battle_party_fleeing.wav",
	"LevelUp": "res://Assets/Audio/SFX/General/Battle/level_up.wav",
	
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
