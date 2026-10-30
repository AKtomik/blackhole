extends Sprite2D

@export var rotation_speed: float = 2.0

func _process(delta: float) -> void:
	if visible: 
		rotation += rotation_speed * delta
