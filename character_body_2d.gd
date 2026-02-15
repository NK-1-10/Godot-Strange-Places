extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var jumps = 0;
var jump_max = 2;


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and $"..".doubleJump == false:
		velocity.y = JUMP_VELOCITY

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and jumps < jump_max and $"..".doubleJump == true:
		jumps = jumps+1;
		velocity.y = JUMP_VELOCITY
		if is_on_floor():
			jumps = 0;

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
