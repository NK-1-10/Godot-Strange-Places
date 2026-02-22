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
var AntiG = false
var doubleJump = false
var dash = false
var dashing = false
var MoveDir = 1
var DashSpeed = 750
var PowerUsed = false
var natural = true

func _ready() -> void:
	$CanvasLayer/Death.visible = false
	add_to_group("Character")
	SetColor()
	natural = true
	_Purple1()
	in_Main_Levels()

func _physics_process(delta: float) -> void:
	# DASH KONTROLE
	if Input.is_action_just_pressed("Dash") and !dashing and !PowerUsed and dash:
		if has_node("Sounds/dash"):
			$Sounds/dash.play()
		dashing = true
		PowerUsed = true
		get_node("DashLength").start()
		SetColor()
	
	if dashing:
		velocity = Vector2(DashSpeed * MoveDir, 0)
		move_and_slide()
		return
	
	# GRAVITĀCIJA
	if !AntiG:
		velocity += get_gravity() * delta
		up_direction = Vector2.UP
	else:
		velocity += get_gravity() * delta * -1
		up_direction = Vector2.DOWN
	
	# GRAVITĀCIJAS MAIŅA
	if Input.is_action_just_pressed("ReverseGravity"):
		if has_node("Sounds/AntiGSound"):
			$Sounds/AntiGSound.play()
		if AntiG:
			natural = true
			AntiG = false
			dash = true
			Particles.position = Vector2(0, 8)
		else:
			AntiG = true
			doubleJump = false
			dash = false
			Particles.position = Vector2(0, -8)
		SetColor()

	# LĒCIENA GARUMA KONTROLE
	if Input.is_action_just_released("Jump"):
		if (!AntiG and velocity.y < 0) or (AntiG and velocity.y > 0):
			velocity.y *= 0.5
	
	# ZEMES PĀRBAUDE
	if is_on_floor() or (AntiG and is_on_ceiling()):
		Can_Jump = true
		if PowerUsed:
			PowerUsed = false
			SetColor()
		get_node("JumpGrace").stop()
	else:
		if get_node("JumpGrace").is_stopped():
			get_node("JumpGrace").start()
	
	# LĒKŠANA
	if Input.is_action_just_pressed("Jump"):
		Wants_jump = true
		get_node("JumpBuffer").start()
	
	if Wants_jump:
		var jump_force = JUMP_VELOCITY if !AntiG else -JUMP_VELOCITY
		if Can_Jump:
			if has_node("Sounds/JumpSound"):
				$Sounds/JumpSound.play()
			Wants_jump = false
			Can_Jump = false
			velocity.y = jump_force
			JumpParticles.emitting = true
		elif !PowerUsed && doubleJump:
			velocity.y = jump_force
			Wants_jump = false
			PowerUsed = true
			JumpParticles.emitting = true
			SetColor()
	
	# KUSTĪBA (PA KREISI / PA LABI)
	var direction := Input.get_axis("Left", "Right")
	if direction:
		MoveDir = direction
		velocity.x += direction * Acceleration
		if abs(velocity.x) > Max_SPEED:
			velocity.x = Max_SPEED * direction
	else:
		velocity.x -= velocity.x * Deceleration
		if abs(velocity.x) < 50:
			velocity.x = 0
	
	RunParticles.emitting = velocity.x != 0
	RunParticles.gravity = Vector2(-90 * MoveDir, 0)
	
	move_and_slide()

func reset_player_state():
	velocity = Vector2.ZERO
	AntiG = false
	doubleJump = false
	dash = false
	dashing = false
	PowerUsed = false
	natural = true
	up_direction = Vector2.UP
	Particles.position = Vector2(0, 8)
	SetColor()

func _on_ouch_ouch_box_area_entered(area: Area2D) -> void:
	# SADURSME AR ĒRKŠĶIEM / NĀVE
	if area.is_in_group("spikes") || area.is_in_group("NoZone"):
		if has_node("Sounds/SpikeDeathSound"):
			$Sounds/SpikeDeathSound.play()
		$DeadParticles.color = $ColorRect.color
		$DeadParticles.emitting = true
		
		reset_player_state()
		
		if area.get("RespawnPoint") != null:
			global_position = area.RespawnPoint.global_position
			
		$CanvasLayer/Death.visible = true
		get_tree().paused = true
	
	# VIENKĀRŠA BUMBU SAVĀKŠANA (bez UI)
	if area.is_in_group("balls"):
		if has_node("Sounds/DingSound"):
			$Sounds/DingSound.play()
		area.queue_free()

func SetColor():
	if PowerUsed:
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
	elif natural:
		$ColorRect.color = Color(0.6, 0.2, 0.8, 1.0)
		_Purple1()
	get_tree().call_group("balls", "update_visuals", doubleJump, AntiG, dash)

func _input(event):
	if event.is_action_pressed("Switch") and Can_Jump:
		doubleJump = !doubleJump
		dash = !doubleJump
		SetColor()

func in_Main_Levels():
	if has_node("../background") || has_node("../BGround"):
		if has_node("Sounds/Background music"):
			$"Sounds/Background music".play()
	if natural:
		AntiG = false
		doubleJump = false
		dash = false

func _handle_bg(mode: String):
	var bgs = [get_node_or_null("../background"), get_node_or_null("../BGround")]
	for bg in bgs:
		if bg:
			for child in bg.get_children():
				var is_target = child.name.to_lower().contains(mode.to_lower())
				child.visible = is_target

func _Red1(): _handle_bg("red")
func _Blue1(): _handle_bg("blue")
func _Purple1(): _handle_bg("purp")
func _Green1(): _handle_bg("green")

func _on_button_pressed():
	get_tree().paused = false
	$CanvasLayer/Death.visible = false

func _on_jump_buffer_timeout(): Wants_jump = false
func _on_jump_grace_timeout(): Can_Jump = false
func _on_dash_length_timeout(): dashing = false

func _on_orb_detector_area_entered(_area):
	if velocity.y > 0: velocity.y = -60
	if PowerUsed:
		PowerUsed = false
		SetColor()
