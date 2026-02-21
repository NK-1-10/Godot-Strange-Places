extends Area2D

var Activated = false
var Text_Box = preload("res://text_box.tscn")

@export var TextLines: Array
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	if(!Activated):
		Activated = true
		
		var instance = Text_Box.instantiate()
		get_parent().get_node("Character").get_node("DynamicCamera").get_node("Camera2D").get_node("Control").add_child(instance)
		
		var TextLabel = instance.get_node("Panel").get_node("Label")
		for Str in TextLines:
			TextLabel.text = Str
			await get_tree().create_timer(3).timeout
		
		instance.queue_free()
