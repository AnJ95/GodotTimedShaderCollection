tool
extends Control

onready var ease_manager = get_tree().get_nodes_in_group("EaseManager")[0]

export (bool) var set_uniform_from_ease_manager = true
export (String) var ease_manager_uniform = "intensity"
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
		var label = Label.new()
		var slider = HSlider.new()
		
		label.text = uniform_info[0]
		slider.min_value = float(uniform_info[1])
		slider.step = float(uniform_info[2])
		slider.max_value = float(uniform_info[3])
		slider.value = float(uniform_info[4])
		
		label.rect_min_size.x = 65
		slider.rect_min_size.x = 140
		
		hboxcontainer.add_child(label)
		hboxcontainer.add_child(slider)
		
		container.add_child(hboxcontainer)
		
		slider.connect("value_changed", self, "_on_shader_uniform_changed", [uniform_info[0]])
		_on_shader_uniform_changed(slider.value, uniform_info[0])

func _ready():
	_set_shader_uniforms(shader_uniforms)

func _process(delta):
	if ease_manager and set_uniform_from_ease_manager:
		material.set_shader_param(ease_manager_uniform, ease_manager.get_cur_value())
	
func _on_shader_uniform_changed(value, uniform:String):
	material.set_shader_param(uniform, value)
