extends AudioStreamPlayer2D

@onready var bg_sfx = $"."

func _on_finished():
	bg_sfx.play()
