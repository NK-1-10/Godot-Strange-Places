extends CharacterBody2D


const Max_SPEED = 250.0
const JUMP_VELOCITY = -400.0
const Acceleration = 100
const Deceleration = 0.2

@onready var Particles = $Particles
@onready var RunParticles = $Particles/RunParticles
@onready var JumpParticles = $Particles/JumpParticles


var Wants_jump = false
var Can_Jump = false

var AntiG = false;
var doubleJump = false;
var dash = false;
var dashing = false
var MoveDir = 1
var DashSpeed = 750
var PowerUsed = false
var natural = true

func _Red1():
	$"../background/ourple".visible = false
	$"../background/blue".visible = false
	$"../background/green".visible = false
	$"../background/red".visible = true
func _Blue1():
	$"../background/ourple".visible = false
	$"../background/blue".visible = true
	$"../background/green".visible = false
	$"../background/red".visible = false
func _Purple1():
	$"../background/ourple".visible = true
	$"../background/blue".visible = false
	$"../background/green".visible = false
	$"../background/red".visible = false
func _Green1():
	$"../background/ourple".visible = false
	$"../background/blue".visible = false
	$"../background/green".visible = true
	$"../background/red".visible = false

func _ready() -> void:
	SetColor()
	add_to_group("Character")
	natural = true;
	_Purple1()
	
	
	if natural == true:
		var AntiG = false;
		var doubleJump = false;
		var dash = false;



func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Dash") and !dashing and !PowerUsed and dash:
		dashing = true
		PowerUsed = true
		get_node("DashLength").start()
		SetColor()
	
	if dashing:
		velocity = Vector2(DashSpeed*MoveDir, 0);
		move_and_slide()
		return
	
	if AntiG == false:
		velocity += get_gravity() * delta
		up_direction = Vector2.UP
		natural = true;
	
	if AntiG == true:
		velocity += get_gravity() * delta * -1
		up_direction = Vector2.DOWN
	
	
	if Input.is_action_just_pressed("ReverseGravity"):
		$Sounds/AntiGSound.play();
		if AntiG == true:
			natural = true;
			AntiG = false;
			dash = true
			Particles.position = Vector2(0, 8)
			SetColor()
		elif AntiG == false:
			AntiG = true;
			doubleJump = false;
			dash = false
			Particles.position = Vector2(0, -8)
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
			JumpParticles.emitting = false
			$Sounds/JumpSound.play()
			JumpParticles.emitting = true
			Wants_jump = false
			Can_Jump = false
			velocity.y = jump_force
		elif !PowerUsed && doubleJump:
			JumpParticles.emitting = false
			JumpParticles.emitting = true
			velocity.y = jump_force
			Wants_jump = false
			PowerUsed = true
			SetColor()
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	
	if direction:
		MoveDir = direction
		velocity.x += direction * Acceleration
		if(abs(velocity.x) > Max_SPEED):
			velocity.x = Max_SPEED * direction
	else:
		velocity.x -= velocity.x * Deceleration
		if(abs(velocity.x) < 50):
			velocity.x = 0
	
	if velocity.x != 0:
		RunParticles.gravity = Vector2(-90 * MoveDir, 0)
		RunParticles.emitting = true
	else:
		RunParticles.gravity = Vector2(-90 * MoveDir, 0)
		RunParticles.emitting = false
	
	move_and_slide()


func _on_jump_buffer_timeout() -> void:
	Wants_jump = false

func _on_jump_grace_timeout() -> void:
	Can_Jump = false

func SetColor():
	if(PowerUsed):
		$ColorRect.color = Color(0.6, 0.2, 0.8, 1.0)
		_Purple1()
	elif AntiG:
		$ColorRect.color = Color(0.314, 0.745, 0.318, 1.0)
		_Green1()
	elif doubleJump:
		$ColorRect.color = Color(0.847, 0.239, 0.133, 1.0)
		_Red1()
	elif dash:
		$ColorRect.color = Color(0.148, 0.481, 0.85, 1.0)
		_Blue1()
	elif natural :
		$ColorRect.color = Color(0.6, 0.2, 0.8, 1.0)
		_Purple1()
		
	get_tree().call_group("balls", "update_visuals", doubleJump, AntiG, dash)
	
	
	
	
	
	
	
	
	
	

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
	if area.is_in_group("spikes") || area.is_in_group("NoZone"):
		$Sounds/SpikeDeathSound.play()
		$DeadParticles.color = $ColorRect.color
		$DeadParticles.emitting = true
		global_position = area.RespawnPoint.global_position 
	
	if area.is_in_group("balls"):
		$Sounds/DingSound.play() 
		area.queue_free() # Bumba pazūd


func _on_orb_detector_area_entered(area: Area2D) -> void:
	if velocity.y > 0:
		velocity.y = -60
	
	if(PowerUsed):
		PowerUsed = false
		SetColor()
	


func _on_dash_length_timeout() -> void:
	dashing = false
