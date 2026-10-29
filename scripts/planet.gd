class_name Planet
extends Area2D

@export var draging_sprite : Sprite2D
@export var link_line : Line2D

signal planet_clicked(Planet)
signal planet_hovered(Planet)

func _ready() -> void:
	draging_sprite.visible = false
	link_line.visible = false 

func _process(_delta: float) -> void:
	if (is_last): line_to(get_global_mouse_position())

# GRAPHISM

var line_max_range 

func line_to(global_to_pos: Vector2, skip_range_cap: bool = false):
	var local_to_pos = global_to_pos - position
	if (!skip_range_cap && position.distance_to(global_to_pos) > line_max_range):
		local_to_pos = local_to_pos.normalized() * line_max_range
	print("set_point_position(1, ", local_to_pos, ")")
	link_line.set_point_position(1, local_to_pos)


# STATES

var is_clickable : bool = true
var is_selected : bool = false
var is_last : bool = false

func join_constelation(join_range: float):
	is_selected = true
	is_last = true
	is_clickable = false
	draging_sprite.visible = true
	link_line.visible = true
	line_max_range = join_range

func constelation_link(next_planet: Planet):
	is_last = false
	line_to(next_planet.position, true)

func cancel_constelation():
	is_selected = false
	is_last = false
	is_clickable = true
	draging_sprite.visible = false
	link_line.visible = false

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
