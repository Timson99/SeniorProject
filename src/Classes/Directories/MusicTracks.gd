extends Resource

class_name MusicTracks

const tracks: Dictionary = {
	
	# General
	"Battle Commence": "res://Assets/Audio/Music/General/Battle Commence!.wav", # Regular Battle Intro
	"Cosmic Explorers": null, # Regular Battle Theme
	"Galactic Barrier": null, # Boss Battle Theme
	
	# Area 01
	"Opening Curtain...": "res://Assets/Audio/Music/Area01/Opening Curtain....wav",
	"No Place Like Home": "res://Assets/Audio/Music/Area01/No Place Like Home.wav",
	"Bully Encounter!": null, #WIP
	"Smooth Player (Bully Boss Fight)": null, # WIP
	# Short track for falling back into bed?
	# Short track after opening door w/ title card?
	
	# Area 02 
	"Foreign Hallways": null,
	
	# Placeholder songs for midscene song changes
	"Test Scene Switch": "res://Assets/Music/Cosmic_Explorers (temp).ogg",
	"Test Battle": "res://Assets/Audio/Music/Demos/Smooth_Player_(Synth_only).ogg"
	}
	
static func get_track(track_title):
	return tracks[track_title]
