class_name BlackHole
extends Node2D

@export var planets_amount : int = 30
@export var planets_scenes : Array[PackedScene] = []
@export var camera : Camera2D
@export var planets_parent : Node2D

func _ready() -> void:
	for i in range(planets_amount):
		print("spawn planet ", i)
		var planet_packed : PackedScene = planets_scenes.pick_random()
		var planet_node : Node2D = planet_packed.instantiate()
		planets_parent.add_child(planet_node)
		var rect : Rect2 = camera.get_viewport_rect()
		var rand_pos = Vector2(
			randf_range(rect.position.x, rect.position.x+rect.size.x) - rect.size.x/2,
			randf_range(rect.position.y, rect.position.x+rect.size.y) - rect.size.y/2
			)
		planet_node.global_position = rand_pos

func _process(delta: float) -> void:
	pass
