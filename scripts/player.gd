extends CharacterBody2D


const SPEED = 300.0
var JUMP_VELOCITY = -400.0
const AIR_FRICTION = 0.7
var direction
var is_hurt := false
var can_jump := true
var double_jump := true

@export var jump_height := 120
@export var max_time_to_peak := 0.5

var gravity# = ProjectSettings.get_setting("physics/2d/default_gravity")
var fall_gravity


@onready var anim = $anim
@onready var coyote_timer = $coyote_timer

signal player_has_died()

func _ready():
	JUMP_VELOCITY = (jump_height * 2) / max_time_to_peak
	gravity = (jump_height * 2) / pow(max_time_to_peak,2)
	fall_gravity = gravity * 2

func _physics_process(delta):
	velocity.x = 0

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and can_jump:
		velocity.y = -JUMP_VELOCITY
	elif Input.is_action_just_pressed("ui_accept") and double_jump:
		velocity.y = -JUMP_VELOCITY
		double_jump = false
	
	if velocity.y >0 or not Input.is_action_pressed("ui_accept"):
		velocity.y += fall_gravity * delta
	else: 
		velocity.y += gravity * delta
	
	if is_on_floor() and !can_jump:
		can_jump = true
		double_jump = true
	elif can_jump and coyote_timer.is_stopped():
		coyote_timer.start()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("left", "right")
	
	if direction:
		velocity.x = lerp(velocity.x, direction * SPEED, AIR_FRICTION)
		anim.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	_set_state()

	move_and_slide()

func _set_state():
	var state = "idle"
	
	if is_hurt:
		state = "hurt"
	elif !is_on_floor():
		state = "jump"
	elif direction:
		state = "run"
	
	if anim.name != state:
		anim.play(state)

func _on_coyote_timer_timeout():
	can_jump = false


func _on_hurtbox_body_entered(_body):
	if $ray_right.is_colliding():
		pass
	elif $ray_left.is_colliding():
		pass
