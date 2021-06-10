tool
extends Node2D

onready var background:Sprite = $CanvasLayer/Background

func _process(delta):
	if background:
		background.region_rect.position.x += 52 * delta
