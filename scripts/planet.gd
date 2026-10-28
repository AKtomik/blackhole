class_name Planet
extends Area2D

@export var draging_sprite : Sprite2D

func _ready() -> void:
	draging_sprite.visible = false

func _process(delta: float) -> void:
	if (is_dragging && Input.is_action_just_released("left_click")):
		release_constelation()


# STATES
var is_clickable : bool = true
var is_dragging : bool = false
var linking_planets : Array[Planet] = []

# start a constelation with this star
func start_constelation():
	draging_sprite.visible = true
	linking_planets = [self]
	is_dragging = true
	
func release_constelation():
	print("have linked ", linking_planets.size(), " planets")
	draging_sprite.visible = false
	linking_planets = []
	is_dragging = false


# INPUTS
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("left_click"):
		print("mouse click on planet ", self, "with event", event)
		start_constelation()

func _on_mouse_entered() -> void:
	print("mouse enter on planet ", self)

func _on_mouse_exited() -> void:
	print("mouse exit on planet ", self)
