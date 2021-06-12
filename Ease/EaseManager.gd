tool
extends PanelContainer

signal ease_manager_changed(texture, duration)

export(int, 2, 2048) var texture_resolution = 100

onready var ease_selects = [
	$HBoxContainer/EaseSelectAttack,
	$HBoxContainer/EaseSelectSustain,
	$HBoxContainer/EaseSelectDecay,
	$HBoxContainer/EaseSelectBreak
]
onready var textRect = $HBoxContainer/VBoxContainer/TextureRect

var cur_time = 0
var cur_value = 0

var times = []
var time_sum = 0

func _ready():
	$HBoxContainer/VBoxContainer/HBoxContainer/SpinBoxTextRes.value = texture_resolution
	_on_ease_select_changed()
	
func _process(delta):
	if !ease_selects: return
	
	cur_time = fmod(cur_time + delta, time_sum)
	for ease_select in ease_selects:
		ease_select.hide_knob()
	cur_value = get_value_at(cur_time)

func get_value_at(rel_time):
	for i in range(times.size()):
		if rel_time > times[i]:
			rel_time -= times[i]
		else:
			return ease_selects[i].get_at_time(rel_time)
	
func get_cur_value():
	return cur_value

func _on_ease_select_changed():
	if !ease_selects: return
		
	# Recalc properties
	times = []
	time_sum = 0
	for ease_select in ease_selects:
		times.append(ease_select.duration)
		time_sum += ease_select.duration
	
	# Create and customize image
	var texture = ImageTexture.new()
	var image = Image.new()
	image.create(texture_resolution, 1, false, Image.FORMAT_RF)
	
	# Set pixels
	image.lock()
	var time_d = time_sum / (texture_resolution)
	for i in range(texture_resolution):
		var t = time_d * (i + 0.5)
		var v = get_value_at(t)
		image.set_pixel(i, 0, Color(v, 0, 0))
	image.unlock()
	
	# Display it
	texture.create_from_image(image)
	textRect.texture = texture
	
	# Notify
	emit_signal("ease_manager_changed", texture, time_sum)

func _on_SpinBoxTextRes_value_changed(value):
	texture_resolution = value
	_on_ease_select_changed()
