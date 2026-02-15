extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED = 3

var jumps = 0;
var jump_max = 2;


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and $"..".doubleJump == false:
		velocity.y = JUMP_VELOCITY

	# Handle jump.
	if is_on_floor():
		jumps = 0

	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor() or ($"..".doubleJump == true and jumps < jump_max):
			velocity.y = JUMP_VELOCITY
			jumps += 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		if $"..".dash == true:
			velocity.x = direction * SPEED * DASH_SPEED
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func start_dash():
	$"..".dash = true
	$dash_timer.connect("timeout", stop_dash)
	$dash_timer.start()
		
func stop_dash():
	$"..".dash = false
