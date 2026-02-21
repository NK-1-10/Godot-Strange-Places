extends Control
var Animator = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Animator = $AnimationPlayer


func _on_button_button_down() -> void:
		Animator.play("new_animation");


func _on_texture_button_button_down() -> void:
	Global.In("res://main.tscn")


func _on_texture_button_2_button_down() -> void:
	pass # Replace with function body.


func _on_texture_button_3_button_down() -> void:
	pass # Replace with function body.
