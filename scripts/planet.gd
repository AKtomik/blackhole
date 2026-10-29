class_name Planet
extends Area2D

@export var draging_sprite : Sprite2D
signal planet_clicked(Planet)
signal planet_hovered(Planet)

func _ready() -> void:
	draging_sprite.visible = false

# STATES

var is_clickable : bool = true
var is_dragging : bool = false

func join_constelation():
	is_dragging = true
	draging_sprite.visible = true

func cancel_constelation():
	is_dragging = false
	draging_sprite.visible = false

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
