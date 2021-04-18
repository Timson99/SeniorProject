extends ExploreRoot

export var enemies_spawnable: bool = true
export var max_enemies = 7
export var enemy_variations = ["FoxEnemy"]

func _ready():
	if not BgEngine._music_player.is_playing():
		BgEngine.request_playback("Foreign Hallways", true) # Fade-in blocked	
