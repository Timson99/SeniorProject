extends ExploreRoot

export var enemies_spawnable: bool = true
export var max_enemies = 5
export var enemy_variations = ["FoxEnemy"]

func _ready():
	if !AudioManager._music_player.is_playing():
		AudioManager.request_playback("Foreign Hallways")
	
