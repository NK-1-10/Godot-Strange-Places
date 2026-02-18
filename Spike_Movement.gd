extends Area2D
@export var Displacements: Array[Vector2]
var Tweens = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var i = Displacements.size()
	var x = 0
	
	if(i<=1):
		return
	
	while(true):
		var NewPos = Displacements[x]
		var tween = create_tween()
		tween.tween_property(self, "position", NewPos, 1)
		tween.play()
		await get_tree().create_timer(1).timeout
		x+=1
		if(x>i-1):
			x=0
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
