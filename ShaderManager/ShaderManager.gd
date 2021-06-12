tool
extends Control

onready var ease_manager = get_tree().get_nodes_in_group("EaseManager")[0]

export (Array, String) var shader_uniforms = ["period,0.1,0.05,1,0.5"] setget _set_shader_uniforms

func _set_shader_uniforms(v):
	shader_uniforms = v
	
	if not has_node("PanelContainer/VBoxContainer"):
		return
		
	var container:Control = $PanelContainer/VBoxContainer
	
	for child in container.get_children():
		child.queue_free()
	
	for uniform_str in shader_uniforms:
		var uniform_info = uniform_str.split(",")
		
		var hboxcontainer = HBoxContainer.new()
		var lblTitle = Label.new()
		var slider = HSlider.new()
		var lblValue = Label.new()
		
		lblTitle.text = uniform_info[0]
		slider.min_value = float(uniform_info[1])
		slider.step = float(uniform_info[2])
		slider.max_value = float(uniform_info[3])
		slider.value = float(uniform_info[4])
		lblValue.align = Label.ALIGN_RIGHT
		
		lblTitle.rect_min_size.x = 65
		slider.rect_min_size.x = 140
		lblValue.rect_min_size.x = 40
		
		hboxcontainer.add_child(lblTitle)
		hboxcontainer.add_child(slider)
		hboxcontainer.add_child(lblValue)
		
		container.add_child(hboxcontainer)
		
		slider.connect("value_changed", self, "_on_shader_uniform_changed", [uniform_info[0], lblValue])
		_on_shader_uniform_changed(slider.value, uniform_info[0], lblValue)

func _ready():
	_set_shader_uniforms(shader_uniforms)

func _on_shader_uniform_changed(value, uniform:String, lblValue:Label):
	material.set_shader_param(uniform, value)
	lblValue.text = str(value)

func _on_ease_manager_changed(texture, duration, loop):
	material.set_shader_param("intensity_texture", texture)
	material.set_shader_param("intensity_duration", duration)
	material.set_shader_param("intensity_loop", loop)

func _on_play_shader():
	# Get absolute time since Engine start
	# taking TIME rollover into account
	# https://docs.godotengine.org/en/3.3/tutorials/shading/shading_reference/canvas_item_shader.html#global-built-ins
	var rollover = ProjectSettings.get_setting("rendering/limits/time/time_rollover_secs")
	var time = fmod(OS.get_ticks_msec() / 1000.0, rollover)
	
	material.set_shader_param("intensity_time_offset", time)
	
	
