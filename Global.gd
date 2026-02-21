extends Node

var SceneChangingpreload = preload("res://scene_change.tscn")
var SceneAnimator = null

func _ready() -> void:
	_setup_transition()

func _setup_transition():
	# Izdzēšam veco animatoru, ja tāds ir
	if is_instance_valid(SceneAnimator) and SceneAnimator.get_parent():
		SceneAnimator.get_parent().queue_free()
	
	var NewScene = SceneChangingpreload.instantiate()
	# Pievienojam pie 'root', jo tas nekad nepazūd
	get_tree().root.add_child.call_deferred(NewScene)
	
	# Pagaidām mazu brīdi, lai mezgls paspēj pievienoties
	await get_tree().process_frame
	SceneAnimator = NewScene.get_child(1)
	SceneAnimator.play("Out")

func In(Path):
	if is_instance_valid(SceneAnimator):
		SceneAnimator.play("In")
		await get_tree().create_timer(1).timeout
	
	var error = get_tree().change_scene_to_file(Path)
	if error != OK:
		print("Kļūda ielādējot līmeni: ", Path)
	
	await get_tree().process_frame 
	_setup_transition()
