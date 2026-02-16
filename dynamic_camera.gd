extends Node2D

@onready var Cam: Camera2D = $Camera2D
@onready var Area: Area2D = $Area2D

var CurrentZone = null

func _process(delta: float) -> void:
	var _Areas = Area.get_overlapping_areas()
	if(_Areas.size() == 0):
		Cam.limit_bottom = 10000
		Cam.limit_top = -10000
		Cam.limit_right = 10000
		Cam.limit_left = -10000
	else:
		CurrentZone = _Areas[_Areas.size() - 1]
		Cam.limit_bottom = CurrentZone.Zone.global_position.y + CurrentZone.Zone.shape.extents.y
		Cam.limit_top = CurrentZone.Zone.global_position.y - CurrentZone.Zone.shape.extents.y
		Cam.limit_right = CurrentZone.Zone.global_position.x + CurrentZone.Zone.shape.extents.x
		Cam.limit_left = CurrentZone.Zone.global_position.x - CurrentZone.Zone.shape.extents.x
