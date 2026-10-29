class_name BlackHole
extends Node2D

# the amount of planets required to finisha constelation
var constelation_required_planet_amount : int = 5
var constelation_maximal_planet_distance : float = 3

func _process(delta: float) -> void:
	constelation_release_check()

# GENERATION

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

# CONSTELATION MANAGEMENT

func planets_ready() -> void:
	for child in planets_parent.get_children():
		if child is Planet:
			child.planet_clicked.connect(start_constelation)
			child.planet_hovered.connect(join_constelation)

func constelation_release_check() -> void:
	if (is_linking() && Input.is_action_just_released("left_click")):
		release_constelation()

# STATES

var linking_planets : Array[Planet] = []

func is_linking() -> bool:
	return !linking_planets.is_empty()

# start a constelation with this star
func start_constelation(planet: Planet):
	if (is_linking()):
		print_debug("trying to start a constelation but making already one!")
		return
	linking_planets = [planet]
	planet.join_constelation()

# join the current constelation build
func join_constelation(planet: Planet):
	if (!is_linking()):
		print_debug("trying to join a constelation but not making one!")
		return
	linking_planets = [planet]
	planet.join_constelation()
	
func release_constelation():
	if (linking_planets.size() >= constelation_required_planet_amount):
		print("have linked ", linking_planets.size(), " planets")
		for planet in linking_planets: planet.finish_constelation()
	else:
		print("failed linking ", linking_planets.size(), " planets")
		for planet in linking_planets: planet.cancel_constelation()
	linking_planets = []
