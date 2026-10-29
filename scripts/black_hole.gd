class_name BlackHole
extends Node2D

# the amount of planets required to finish a constelation
var constelation_required_planet_amount : int = 5
# the max distance between to planets to link both
var constelation_maximal_planet_distance : float = 100

func _process(delta: float) -> void:
	if (is_linking() && Input.is_action_just_released("left_click")):
		release_constelator()

func _ready() -> void:
	create_constellation(planets_amount)

# GENERATION

@export var planets_amount : int = 30
@export var planets_scenes : Array[PackedScene] = []
@export var camera : Camera2D
@export var planets_parent : Node2D

#region planets generation
## Entrée : Number un entier |
## Sortie : Rien |
## Action : Crée la constellation du niveau composé d'autant d'étoiles que données en entrée
func create_constellation(number : int) -> void :
	var coordinates = create_coordinates(number)
	for i in coordinates:
		print("spawn planet ", i)
		spawn_planet(i)
	planets_ready()# usefull for link clicks

## Entrée : amount un entier (int) |
## Sortie : result un une liste de vecteurs (Array[Vector2]) |
## Action : Crée autant de coordonnées que précisé en entrée et les retourne sous forme de liste |
func create_coordinates(amount : int) -> Array[Vector2] :
	var result : Array[Vector2] = []
	var rect : Rect2 = camera.get_viewport_rect()
	var current_degree = 0
	var degree_step = 360/amount
	var blackhole_offset = 300
	
	for i in range(amount):
		var x = cos(current_degree)*blackhole_offset
		var y = sin(current_degree)*blackhole_offset
		#sqrt only returns positive values, we want y to be negative when drawing the bottom of the circle (0 - 180 degrees)
		if current_degree < 180 :
			y = -y
		var rand_pos = Vector2(x, y)
		current_degree += degree_step
		
		result.append(rand_pos)
	return result

## Entrée : coo un vecteur
## Sortie : Rien |
## Action : Fait apparaître une planète/étoile aux coordonnées données
func spawn_planet(coo : Vector2) -> void :
	var planet_packed : PackedScene = planets_scenes.pick_random()
	var planet_node : Node2D = planet_packed.instantiate()
	planets_parent.add_child(planet_node)
	planet_node.global_position = coo

#endregion

#region constelation link click

# LINK CLICK

func planets_ready() -> void:
	for child in planets_parent.get_children():
		if child is Planet:
			child.planet_clicked.connect(start_constelator)
			child.planet_hovered.connect(join_constelator)

# LINK STATE

var linking_planets : Array[Planet] = []

func is_linking() -> bool:
	return !linking_planets.is_empty()


# start a constelation with this star
func start_constelator(planet: Planet):
	if (is_linking()):
		print_debug("trying to start a constelation but making already one!")
		return
	linking_planets = [planet]
	planet.join_constelation(constelation_maximal_planet_distance)


# join the current constelation in build
func join_constelator(planet: Planet):
	if (!is_linking()):
		print_debug("trying to join a constelation but not making one!")
		return
	
	var last_planet = linking_planets[linking_planets.size() - 1]
	var planet_distance = planet.position.distance_to(last_planet.position)
	if (planet_distance > constelation_maximal_planet_distance): return
	
	last_planet.constelation_link(planet)
	linking_planets.append(planet)
	planet.join_constelation(constelation_maximal_planet_distance)

	
func release_constelator():
	if (linking_planets.size() >= constelation_required_planet_amount):
		print("have linked ", linking_planets.size(), " planets")
		for planet in linking_planets: planet.finish_constelation()
	else:
		print("failed linking ", linking_planets.size(), " planets")
		for planet in linking_planets: planet.cancel_constelation()
	linking_planets = []

#endregion
