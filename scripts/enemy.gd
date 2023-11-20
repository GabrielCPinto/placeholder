extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var anim = $anim

@export var life := 3

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var sprite
var wall_detector
var direction := -1

func _physics_process(delta):
	_apply_gravity(delta)
	
	move_and_slide()

func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
