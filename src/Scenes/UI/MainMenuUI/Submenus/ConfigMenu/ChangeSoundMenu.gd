extends CanvasLayer

var parent = null

enum Slider{Music, SFX}

var default_focused = Slider.Music
var focused = default_focused

onready var sliders = {
	Slider.Music: {
		"slider": $TextureRect/VBoxContainer/MusicSlider,
		"change_volume": "change_music_volume",
	},
	Slider.SFX: {
		"slider": $TextureRect/VBoxContainer/SFXSlider,
		"change_volume": "change_sfx_volume", 
	}
}

onready var db_range = abs(BgEngine.max_volume_value-BgEngine.min_volume_value)
onready var db_change = floor(db_range / sliders[focused]["slider"].tick_count)
onready var starting_music_vol = BgEngine.baseline_music_volume
onready var starting_sfx_vol = BgEngine.baseline_se_volume

func _ready():
	sliders[Slider.Music]["slider"].value = starting_music_vol
	sliders[Slider.SFX]["slider"].value = starting_sfx_vol
	sliders[default_focused]["slider"].grab_focus()
	if sliders[Slider.Music]["slider"].tick_count != sliders[Slider.SFX]["slider"].tick_count:
		Debugger.dprint("Unequal tick count on music & sfx sliders")


func change_music_volume(new_db: float):
	BgEngine.change_music_volume(new_db)
	
func change_sfx_volume(new_db: float):
	BgEngine.change_sfx_volume(new_db)

func back():
	BgEngine.play_sound("MenuButtonReturn")		
	reset_parent_button()
	queue_free()
		
func accept():
	pass
	
func up():
	focused -= 1
	focused = Slider.Music if focused < Slider.Music else focused
	
func down():
	focused += 1
	focused = Slider.SFX if focused > Slider.SFX else focused

func left():
	self.call(sliders[focused]["change_volume"], sliders[focused]["slider"].value)
	
func right():
	self.call(sliders[focused]["change_volume"], sliders[focused]["slider"].value)
		
		
func reset_parent_button():
	var parent_quit_button = parent.buttons[parent.focused]["selectable_button"]
	parent_quit_button.grab_focus()
