extends Resource

class_name MusicTracks

const tracks: Dictionary = {
	
	# General
	"Cosmic Explorers": "res://Assets/Audio/Music/General/Cosmic Explorers.ogg", # Regular Battle Theme
	"Game Over": "res://Assets/Audio/Music/General/Game Over.ogg", # Game Over Theme
	"Galactic Barrier": null, # Boss Battle Theme
	
	# Area 01
	"No Place Like Home": "res://Assets/Audio/Music/Area01/No Place Like Home.ogg",
	"Bully Encounter": "res://Assets/Audio/Music/Area01/Bully Encounter.ogg",
	"Smooth Player": "res://Assets/Audio/Music/Area01/Smooth Player.ogg",
	# Short track after opening door w/ title card?
	
	# Area 02 
	"Foreign Hallways": "res://Assets/Audio/Music/Area02/Foreign Hallways.ogg",
	
	# Placeholder songs for midscene song changes
	"Test Scene Switch": "res://Assets/Music/Cosmic_Explorers (temp).ogg",
	"Test Battle": "res://Assets/Audio/Music/Demos/Cosmic Explorers.wav"
	}
	
static func get_track(track_title):
	return tracks[track_title]
