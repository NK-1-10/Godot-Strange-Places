extends Area2D
@onready var blue = $Balls_Colour/BlueBall
@onready var red = $Balls_Colour/RedBall
@onready var green = $Balls_Colour/GreenBall
@onready var purple = $Balls_Colour/PurpleBall

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("balls")

func _on_area_entered(area: Area2D) -> void:
	if area.name == "OuchOuchBox":
		queue_free() # Bumba pazūd

func update_visuals(is_double_jump: bool, is_anti_g: bool, dash: bool):
	# Paslēpjam visus modeļus
	purple.visible = false
	blue.visible = false
	red.visible = false
	green.visible = false
	
	# Parādām pareizo krāsu pēc tavas loģikas
	if is_anti_g:
		green.visible = true # Anti-gravity ir prioritāte
	elif is_double_jump:
		red.visible = true   # Ja nav Anti-G, skatāmies Double Jump
	elif dash :
		blue.visible = true  # Ja neviens no tiem, tad Dash (zils)
	else:
		purple.visible = true
