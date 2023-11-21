extends CanvasLayer

@onready var color_rect = $color_rect
@onready var anim = $anim

func _ready():
	anim.play("fade")

func change_scene(path):
	anim.play_backwards("fade")
	await anim.animation_finished
	assert(get_tree().change_scene_to_file(path) == OK)
