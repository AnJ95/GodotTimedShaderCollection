tool
extends Sprite

export(float, 0.01, 0.5) var frame_time = 0.2

func _ready():
	$Timer.start(frame_time)

func _on_Timer_timeout():
	frame = (frame + 1) % hframes
