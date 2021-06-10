tool
extends PanelContainer

var ease_selects = []
var time = 0

var cur_value = 0

func _ready():
	ease_selects = ease_selects
	for ease_select in $HBoxContainer.get_children():
		ease_selects.append(ease_select)
		
func _process(delta):
	if ease_selects.size() == 0:
		return
		
	time += delta
	
	# collect data about times
	var times = []
	var time_sum = 0
	for ease_select in ease_selects:
		times.append(ease_select.duration)
		time_sum += ease_select.duration
		ease_select.hide_knob()
	
	time = fmod(time, time_sum)
	
	var rel_time = time
	for i in range(times.size()):
		if rel_time > times[i]:
			rel_time -= times[i]
		else:
			cur_value = ease_selects[i].get_at_time(rel_time)
			return

func get_cur_value():
	return cur_value
