extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("main")
	$ourple.visible = true
	$blue.visible = false
	$green.visible = false
	$red.visible = false
	

func update_visuals(is_double_jump: bool, is_anti_g: bool, dash: bool):
	if is_anti_g:
		$green.visible = true # Anti-gravity ir prioritāte
	elif is_double_jump:
		$red.visible = true   # Ja nav Anti-G, skatāmies Double Jump
	elif dash :
		$blue.visible = true  # Ja neviens no tiem, tad Dash (zils)
	else:
		$ourple.visible = true
