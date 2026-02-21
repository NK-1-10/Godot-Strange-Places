extends Area2D
@export var RespawnPoint: Node2D # Šim ir jābūt šeit!

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("NoZone")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	# Pārbaudām, vai tas, kas iepeldēja zonā, ir mūsu spēlētājs
	if body is CharacterBody2D: 
		if RespawnPoint != null:
			# Teleportējam tēlu uz respawn punkta pozīciju
			body.global_position = RespawnPoint.global_position
			print("Pieskāriens notika!")
		else:
			print("Kļūda: RespawnPoint nav pievienots Inspector logā!")
