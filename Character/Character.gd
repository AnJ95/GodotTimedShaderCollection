tool
extends Sprite

const frames = [36, 37, 38, 39, 40, 41, 42, 43]

export(float, 0.01, 0.5) var frame_time = 0.2

onready var timer:Timer = $Timer

var cur_frame_id = 0

func _ready():
	timer.start(frame_time)

func _on_Timer_timeout():
	cur_frame_id = (cur_frame_id + 1) % frames.size()
	
	frame = frames[cur_frame_id]
	timer.start(frame_time)
