extends Node2D

@export var planets_amount : int = 30
@export var planets_scenes : Array[PackedScene] = []
@export var spawn_area : RectangleShape2D

func _ready() -> void:
	for i in range(planets_amount):
		var packed : PackedScene = planets_scenes.pick_random()
		var node : Node2D = packed.instantiate()
		var rect : Rect2 = spawn_area.get_rect()
		var rand_spawn = Vector2(randf_range(rect.position.x, rect.position.x+rect.size.x), randf_range(rect.position.y, rect.position.x+rect.size.y)) 
		node.position = global_position + rand_spawn

func _process(delta: float) -> void:
	pass
