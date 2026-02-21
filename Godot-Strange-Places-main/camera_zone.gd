extends Area2D

@export var Zone: CollisionShape2D
var ZoneDimensions: Vector2 = Vector2.ZERO

func _ready() -> void:
	ZoneDimensions = Zone.shape.extents
