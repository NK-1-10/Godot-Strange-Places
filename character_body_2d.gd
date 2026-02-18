extends CharacterBody2D


const Max_SPEED = 250.0
const JUMP_VELOCITY = -400.0
const Acceleration = 100
const Deceleration = 0.2


var Wants_jump = false
var Can_Jump = false

var AntiG = false;
var doubleJump = true;
var dash = false;

var PowerUsed = false

func _ready() -> void:
	SetColor()


func _physics_process(delta: float) -> void:
	
	if AntiG == false:
		velocity += get_gravity() * delta
		up_direction = Vector2.UP
	
	if AntiG == true:
		velocity += get_gravity() * delta * -1
		up_direction = Vector2.DOWN
	
	
	if Input.is_action_just_pressed("ReverseGravity"):
		if AntiG == true:
			AntiG = false;
			SetColor()
		elif AntiG == false:
			AntiG = true;
			SetColor()


	#Ejam augšā un palaiž vaļā
	if Input.is_action_just_released("Jump"):
		if AntiG == false and velocity.y <0:
			velocity.y *= 0.5
		elif AntiG == true and velocity.y > 0:
			velocity.y *= 0.5
	
		
	
	
	if(is_on_floor()):
		Can_Jump = true
		if(PowerUsed):
			PowerUsed=false
			SetColor()
		
		get_node("JumpGrace").stop()
	else:
		if(get_node("JumpGrace").is_stopped()):
			get_node("JumpGrace").start()
	
	
	# Handle jump.
	if Input.is_action_just_pressed("Jump"):
		Wants_jump = true
		get_node("JumpBuffer").start()
	
	if Wants_jump:
		var jump_force = JUMP_VELOCITY
		if AntiG:
			jump_force = -JUMP_VELOCITY #I think šitas dabū upside down jump. correct me if im wrong :>
		if Can_Jump:
			Wants_jump = false
			Can_Jump = false
			velocity.y = jump_force
		elif !PowerUsed && doubleJump:
			velocity.y = jump_force
			Wants_jump = false
			PowerUsed = true
			SetColor()
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	
	if direction:
		velocity.x += direction * Acceleration
		if(abs(velocity.x) > Max_SPEED):
			velocity.x = Max_SPEED * direction
	else:
		velocity.x -= velocity.x * Deceleration
		if(abs(velocity.x) < 50):
			velocity.x = 0
	
	move_and_slide()


func _on_jump_buffer_timeout() -> void:
	Wants_jump = false

func _on_jump_grace_timeout() -> void:
	Can_Jump = false

func SetColor():
	if(PowerUsed):
		$ColorRect.color = Color(1.0, 1.0, 1.0, 1.0)
	elif AntiG:
		$ColorRect.color = Color(0.314, 0.745, 0.318, 1.0)
	elif doubleJump:
		$ColorRect.color = Color(0.847, 0.239, 0.133, 1.0)
	else:
		$ColorRect.color = Color(0.148, 0.481, 0.85, 1.0)

func _input(event):
	if event.is_action_pressed("Switch") and Can_Jump:
		if doubleJump:
			dash = true
			doubleJump = false
			SetColor()
		else:
			doubleJump = true
			dash = false
			SetColor()


func _on_ouch_ouch_box_area_entered(area: Area2D) -> void:
	#resets the scene
	#player die kaput
	get_tree().change_scene_to_file("res://main.tscn")
