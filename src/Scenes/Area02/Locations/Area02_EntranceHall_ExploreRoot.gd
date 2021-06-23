extends ExploreRoot

export var enemies_spawnable: bool = true
export var max_enemies = 5
export var enemy_variations = ["FoxEnemy"]

func _ready():
	AudioManager.play_music("Foreign Hallways")
	
