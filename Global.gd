extends Node

var SceneChangingpreload = preload("res://scene_change.tscn")
var SceneAnimator = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("AAAA")
	var NewScene = SceneChangingpreload.instantiate()
	get_tree().current_scene.add_child(NewScene)
	
	SceneAnimator = NewScene.get_child(1);
	SceneAnimator.play("Out")

func In(Path):
	SceneAnimator.play("In")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file(Path);

func Out(Path):
	SceneAnimator.play("Out")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file(Path);
