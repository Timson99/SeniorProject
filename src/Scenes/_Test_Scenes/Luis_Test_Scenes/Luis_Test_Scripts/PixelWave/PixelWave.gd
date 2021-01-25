extends Node2D

const VU_COUNT = 20#16

const FREQ_MAX = 15000.0#11050.0
const FREQ_MIN = 10

const WIDTH = 100
const HEIGHT = 100

var MIN_DB = -80#60
var MAX_DB = -10
onready var spectrum = AudioServer.get_bus_effect_instance(0,0)

var accel = 5
var histogram = []

func _draw():
	var draw_pos = Vector2(0,0)
	var h_interval = HEIGHT / VU_COUNT
	draw_line(Vector2(WIDTH,0), Vector2(WIDTH,HEIGHT),Color.blue,4.0,true)
	for i in range(VU_COUNT):
		draw_line(draw_pos,draw_pos + Vector2(histogram[i] *WIDTH,0),Color.blue,4.0,true)
		draw_line(draw_pos + Vector2(histogram[i] *WIDTH+1,0),Vector2(draw_pos.x+HEIGHT,draw_pos.y),Color.blue,4.0,true)
		draw_pos.y += h_interval
#func _draw():
#	var w=WIDTH /VU_COUNT
#	var prev_hz = 0
#	for i in range(1, VU_COUNT+1):
#		var hz = i*FREQ_MAX/VU_COUNT
#		var f = spectrum.get_magnitude_for_frequency_range(prev_hz,hz)
#		var energy = clamp((MIN_DB + linear2db(f.length()))/MIN_DB,0,1)
#		var height = energy +HEIGHT
#		draw_rect(Rect2(w+1, HEIGHT-height,w,height),Color(1,1,1))
#		prev_hz=hz

func _process(delta):
	var freq = FREQ_MIN
	var interval = (FREQ_MAX-FREQ_MIN) / VU_COUNT
	for i in range(VU_COUNT):
		var freq_low = float(freq-FREQ_MIN)/float(FREQ_MAX-FREQ_MIN)
		freq_low *=2
		freq_low = lerp(FREQ_MIN,FREQ_MAX,freq_low)
		
		var freq_high = float(freq-FREQ_MIN)/float(FREQ_MAX-FREQ_MIN)
		freq_high *=4
		freq_high = lerp(FREQ_MIN,FREQ_MAX,freq_high)
		
		var mag = spectrum.get_magnitude_for_frequency_range(freq_low,freq_high)
		mag = linear2db(mag.length())
		mag = (mag-MIN_DB)/(MAX_DB-MIN_DB)
		mag+=0.3 + (freq -FREQ_MIN) /(FREQ_MAX-FREQ_MIN)
		mag = clamp(mag, 0.05, 1)
		histogram[i] = lerp(histogram[i],mag,accel*delta)
		freq += interval
	update()
func _ready():
	MAX_DB += get_parent().volume_db
	MIN_DB -= get_parent().volume_db
	for i in range(VU_COUNT):
		histogram.append(0)
