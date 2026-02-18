extends Area2D

var Display
@export var RespawnTime: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Display = $ColorRect
	$Timer.wait_time = RespawnTime


func _on_timer_timeout() -> void:
	Display.visible = true
	self.set_deferred("monitorable", true)
	self.set_deferred("monitoring", true)


func _on_area_entered(area: Area2D) -> void:
	Display.visible = false
	self.set_deferred("monitorable", false)
	self.set_deferred("monitoring", false)
	$Timer.start()
