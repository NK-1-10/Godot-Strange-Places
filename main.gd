extends Node2D
var doubleJump = false;
var dash = false;

func _doubleUp():
	pass

func _input(event):
	if event.is_action_pressed("Double_jump"):
		if doubleJump == false:
			$Basic.modulate = Color(0.148, 0.481, 0.85, 1.0)
			doubleJump = true
			dash = false
		else:
			$Basic.modulate = Color(1.0, 1.0, 1.0, 1.0)
			doubleJump = false
			
	if event.is_action_pressed("Dash"):
		if dash == false:
			$Basic.modulate = Color(0.847, 0.239, 0.133, 1.0)
			doubleJump = false
			dash = true
			$CharacterBody2D.start_dash()
		else:
			$Basic.modulate = Color(1.0, 1.0, 1.0, 1.0)
			dash = false
