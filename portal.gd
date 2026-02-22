extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if has_node("../background"):
		if body.name == "Character":
			Global.In("res://StartMenu.tscn")
	elif has_node("../BGround"):
		if body.name == "Character":
			Global.In("res://end.tscn")
