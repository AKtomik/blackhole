class_name Planet
extends Area2D

@export_group("Textures")
@export var planet_sprite_node : Sprite2D
@export var selected_sprite_node : Sprite2D

@export var sprite_textures : Array[Texture2D]

@export_group("Links")
@export var link_line_node : Line2D
@export var link_ray_node : RayCast2D

signal planet_clicked(Planet)
signal planet_hovered(Planet)

func _ready() -> void:
	selected_sprite_node.visible = false
	link_line_node.visible = false
	planet_sprite_node.texture = sprite_textures.pick_random()

func _process(_delta: float) -> void:
	if (is_last):
		line_to(get_global_mouse_position())
		if (link_ray_node.enabled && link_ray_node.is_colliding()):
			var collider = link_ray_node.get_collider()
			print("colliding with ", collider)
			if (collider is Planet):
				print("collider is a planet!")
				collider.planet_hovered(collider)

# GRAPHISM

var line_max_range: float

func line_to(to_global_pos: Vector2, skip_range_cap: bool = false):
	var to_local_pos = to_global_pos - position
	if (!skip_range_cap && position.distance_to(to_global_pos) > line_max_range):
		to_local_pos = to_local_pos.normalized() * line_max_range
	link_line_node.set_point_position(1, to_local_pos)
	if (link_ray_node.enabled): link_ray_node.target_position = to_local_pos


# STATES

var is_clickable : bool = true
var is_selected : bool = false
var is_last : bool = false

func join_constelation(planet_number: int):
	is_selected = true
	is_last = true
	is_clickable = false
	selected_sprite_node.visible = true
	link_line_node.visible = true
	link_ray_node.enabled = true
	line_to(position)

func constelation_link(next_planet: Planet):
	is_last = false
	line_to(next_planet.position, true)

func cancel_constelation():
	is_selected = false
	is_last = false
	is_clickable = true
	selected_sprite_node.visible = false
	link_line_node.visible = false
	link_ray_node.enabled = false

func finish_constelation():
	queue_free()

# INPUTS

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if !(Input.is_action_just_pressed("left_click") && is_clickable): return
	print("mouse click on planet ", self, "with event", event)
	planet_clicked.emit(self)

func _on_mouse_entered() -> void:
	if !(Input.is_action_pressed("left_click") && is_clickable): return
	print("mouse join planet", self)
	planet_hovered.emit(self)

func _on_mouse_exited() -> void:
	print("mouse exit on planet ", self)
