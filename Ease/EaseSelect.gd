tool
extends VBoxContainer

enum EaseType {
	EASE_IN, EASE_OUT, EASE_IN_OUT, EASE_OUT_IN
}
enum TransitionType {
	TRANS_LINEAR, TRANS_SINE, TRANS_QUINT, TRANS_QUART, TRANS_QUAD, TRANS_EXPO, TRANS_ELASTIC, TRANS_CUBIC, TRANS_CIRC, TRANS_BOUNCE, TRANS_BACK
}

signal ease_select_changed

export(float) var duration = 0.3

export(EaseType) var ease_type = 0
export(TransitionType) var transition_type = 0

export var invert_y = false

export var make_constant = false
export(float, 0, 1) var constant_value = 0.0

onready var color_rect:ColorRect = $ColorRectOuter/ColorRectInner
onready var line2d:Line2D = $ColorRectOuter/ColorRectInner/Line2D
onready var spin_box_duration:SpinBox = $SpinBoxDuration
onready var btn_option_ease:OptionButton = $BtnOptionEase
onready var btn_option_transition:OptionButton = $BtnOptionTransition
onready var tween:Tween = $Tween
onready var knob:ColorRect = $ColorRectOuter/ColorRectInner/Knob

var tween_value

func _ready():
	spin_box_duration.value = duration
	
	btn_option_ease.visible = not make_constant
	btn_option_ease.clear()
	for option in EaseType.keys():
		btn_option_ease.add_item(option)
	btn_option_ease.selected = ease_type
	
	btn_option_transition.visible = not make_constant
	btn_option_transition.clear()
	for option in TransitionType.keys():
		btn_option_transition.add_item(option)
	btn_option_transition.selected = transition_type
	
	update_view()

func update_view():
	var resolution = 100
	
	tween.interpolate_property(self, "tween_value", 0, 1, 1, transition_type, ease_type)
	
	var pts = PoolVector2Array()
	pts.resize(resolution)
	
	for i in range(resolution):
		var x = i / float(resolution-1)
		var y
		
		if make_constant:
			y = constant_value
		else:
			tween.seek(x)
			y = tween_value
		pts.set(i, _proj_to_rect(x,y))
		
	line2d.points = pts

func _proj_to_rect(x, y):
	return Vector2(
		x * color_rect.rect_size.x,
		(y if invert_y else (1 - y)) * color_rect.rect_size.y
	)

func get_at_time(time):
	var value
	if make_constant:
		value = constant_value
		knob.rect_position = _proj_to_rect(time / duration, constant_value) - knob.rect_size / 2
	else:
		tween.interpolate_property(self, "tween_value", 0, 1, duration, transition_type, ease_type)
		tween.seek(time)
		value = 1 - tween_value if invert_y else tween_value 
		knob.rect_position = _proj_to_rect(time / duration, tween_value) - knob.rect_size / 2
		
	knob.visible = true
	return value

func hide_knob():
	knob.visible = false

func _on_SpinBoxDuration_value_changed(value):
	duration = value
	update_view()
	emit()
	
func _on_BtnOptionEase_item_selected(index):
	ease_type = index
	update_view()
	emit()
	
func _on_BtnOptionTransition_item_selected(index):
	transition_type = index
	update_view()
	emit()

func _on_ColorRectInner_resized():
	if !tween: return
	update_view()
	
func emit():
	emit_signal("ease_select_changed")
