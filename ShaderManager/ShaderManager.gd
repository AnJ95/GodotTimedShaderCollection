tool
extends Control

export (Array, String) var shader_uniforms = ["period,0.1,0.05,1,0.5"] setget _set_shader_uniforms

func _ready():
	_set_shader_uniforms(shader_uniforms)
	material.set_shader_param("intensity_time_offset", 0)
	
func _set_shader_uniforms(v):
	shader_uniforms = v
	
	if not has_node("PanelContainer/VBoxContainer"):
		return
		
	var container:Control = $PanelContainer/VBoxContainer/VBoxContainer
	
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
		lblValue.rect_min_size.x = 34
		
		hboxcontainer.add_child(lblTitle)
		hboxcontainer.add_child(slider)
		hboxcontainer.add_child(lblValue)
		
		container.add_child(hboxcontainer)
		
		slider.connect("value_changed", self, "_on_shader_uniform_changed", [uniform_info[0], lblValue])
		_on_shader_uniform_changed(slider.value, uniform_info[0], lblValue)

func _on_shader_uniform_changed(value, uniform:String, lblValue:Label):
	material.set_shader_param(uniform, value)
	lblValue.text = str(value)

func _on_ease_manager_changed(texture, duration):
	material.set_shader_param("intensity_texture", texture)
	material.set_shader_param("intensity_duration", duration)

func _on_play_shader():
	# Get absolute time since Engine start
	# taking TIME rollover into account
	# https://docs.godotengine.org/en/3.3/tutorials/shading/shading_reference/canvas_item_shader.html#global-built-ins
	var rollover = ProjectSettings.get_setting("rendering/limits/time/time_rollover_secs")
	var time = fmod(OS.get_ticks_msec() / 1000.0, rollover)
	
	material.set_shader_param("intensity_time_offset", time)

func _on_BtnSaveMaterial_pressed():
	var fd:FileDialog = FileDialog.new()
	fd.mode = FileDialog.MODE_SAVE_FILE
	fd.filters = PoolStringArray(["*.tres ; Material Resource"])
	fd.current_file = "shader.tres"
	fd.mode_overrides_title = false
	fd.window_title = "Save shader material"
	
	add_child(fd)
	fd.popup_centered_ratio(0.75)
	fd.connect("file_selected", self, "_on_save_material_file_selected")
	
func _on_save_material_file_selected(path):
	var flags = ResourceSaver.FLAG_BUNDLE_RESOURCES | ResourceSaver.FLAG_CHANGE_PATH
	if ResourceSaver.save(path, material, flags) != OK:
		printerr("Could not save the material!")
