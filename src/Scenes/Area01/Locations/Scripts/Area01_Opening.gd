extends Control

onready var intro_text = $RichTextLabel
onready var tween = $Tween

var first_stop = 17
var second_stop = first_stop + 28 
var third_stop = second_stop + 47
var scroll_time = 10

func _ready():
	intro_text.visible_characters = 0
	SceneManager.connect("scene_fully_loaded", self, "display")
	
func display():

	yield(get_tree().create_timer(1, false), "timeout")
	tween.interpolate_property(intro_text, "visible_characters", intro_text.visible_characters, first_stop, first_stop/scroll_time)
	tween.start()
	yield(tween, "tween_completed")
	yield(get_tree().create_timer(1, false), "timeout")
	tween.interpolate_property(intro_text, "visible_characters", intro_text.visible_characters, second_stop, (second_stop - first_stop)/scroll_time)
	tween.start()
	yield(tween, "tween_completed")
	yield(get_tree().create_timer(1, false), "timeout")
	tween.interpolate_property(intro_text, "visible_characters", intro_text.visible_characters, third_stop, (third_stop - second_stop - first_stop)/scroll_time)
	tween.start()
	yield(tween, "tween_completed")
	yield(get_tree().create_timer(2, false), "timeout")
	Sequencer.execute_event("Area01_Sequence01")
	
	
	
	

