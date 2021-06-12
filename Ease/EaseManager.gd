tool
extends PanelContainer

signal play_shaders()
signal ease_manager_changed(texture, duration)

export(bool) var loop = true
export(bool) var filter = true
export(int, 2, 2048) var texture_resolution = 100

onready var ease_selects = [
	$HBoxContainer/EaseSelectAttack,
	$HBoxContainer/EaseSelectSustain,
	$HBoxContainer/EaseSelectDecay,
	$HBoxContainer/EaseSelectBreak
]
onready var textRect = $HBoxContainer/VBoxContainer/TextureRect
onready var btnPlay = $HBoxContainer/VBoxContainer/HBoxContainer4/BtnPlay
onready var rollover = ProjectSettings.get_setting("rendering/limits/time/time_rollover_secs")

var time_offset = 0

var cur_value = 0

var texture
var times = []
var time_sum = 0

func _ready():
	$HBoxContainer/VBoxContainer/HBoxContainer/SpinBoxTextRes.value = texture_resolution
	$HBoxContainer/VBoxContainer/HBoxContainer2/HBoxContainer/CbxLoop.pressed = loop
	$HBoxContainer/VBoxContainer/HBoxContainer3/HBoxContainer/CbxFilter.pressed = filter
	_on_ease_select_changed()
	
func _process(delta):
	if !ease_selects: return
	
	var abs_time = fmod(OS.get_ticks_msec() / 1000.0, rollover) - time_offset
	var rel_time = fmod(abs_time, time_sum) if loop else min(abs_time, time_sum)
	
	for ease_select in ease_selects:
		ease_select.hide_knob()
	cur_value = get_value_at(rel_time)

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
	
	update_texture()

func _on_SpinBoxTextRes_value_changed(value):
	texture_resolution = value
	update_texture()

func _on_CbxLoop_toggled(button_pressed):
	loop = button_pressed
	btnPlay.text = "Reset" if loop else "Play"
	update_texture()
func _on_CbxFilter_toggled(button_pressed):
	filter = button_pressed
	update_texture()
	
func update_texture():
	# Create and customize image
	texture = ImageTexture.new()
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
	
	# Set flags
	texture.create_from_image(image)
	var flags = 0
	if loop: flags |= Texture.FLAG_REPEAT
	if filter: flags |= Texture.FLAG_FILTER
	texture.flags = flags
	
	# Display it
	textRect.texture = texture
	
	# Notify
	emit()

func _on_BtnPlay_pressed():
	time_offset = fmod(OS.get_ticks_msec() / 1000.0, rollover)
	emit_signal("play_shaders")

func emit():
	emit_signal("ease_manager_changed", texture, time_sum)
