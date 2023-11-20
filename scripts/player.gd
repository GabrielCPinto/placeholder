extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var direction
var is_hurt := false
var can_jump := true
var double_jump := true
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = $anim
@onready var coyote_timer = $coyote_timer

signal player_has_died()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_pressed("ui_accept") and double_jump:
		velocity.y = JUMP_VELOCITY
		double_jump = false
		
	if is_on_floor() and !can_jump:
		can_jump = true
		double_jump = true
	elif can_jump and coyote_timer.is_stopped():
		coyote_timer.start()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
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
