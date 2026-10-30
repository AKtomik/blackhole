class_name BlackHole
extends Node2D

# the amount of planets required to finish a constelation
var constelation_required_planet_amount : int = 30
# do finish constelation when required amount is hit
var constelation_required_finish : bool = true
# do set the constelation required amount to planets nomber 
var constelation_required_all : bool = true
# the default max distance between to planets to link both
var constelation_maximal_planet_distance : float = 100
# do check the distance a second time (needed if do_hover_emit_with_mouse is true)
var constelation_second_distance_check : bool = false
#Number of spawn that were made so far, which is the number of the current level
var current_level : int = 0
#If the player has lost yet or not
var game_over = false
#Current sprite displayed from the sprites given
var current_sprite : int = 11
#Node of the sprite of the blackhole
@onready var blackhole_sprite = $Sprite2D
#Node of the timer
@onready var timer = $Timer
#Max time allowed to complete the level (in the first levels)
@export var time_allowed = 20
#Minimum time allowed to complete the level (later levels)
@export var minimum_time = 12
#The step at which the max time allowed decreases when the maximum amount of planets is reached
@export var time_step = 1
#Signal send when the timer runs out and the player looses
signal timeout
#Maximum amount of planets in a level
@export var max_planets = 30

func _process(delta: float) -> void:
	if (is_linking() && Input.is_action_just_released("left_click")):
		release_constelator()
	check_for_blackhole_sprite_change()

func _ready() -> void:
	start_level()

# GENERATION

@export var planets_amount : int = 2
@export var min_planet_spacing = 50
@export var planets_scenes : Array[PackedScene] = []
@export var camera : Camera2D
@export var planets_parent : Node2D
@export var planet_scale : float = 1

#region planets generation
func start_level() -> void :
	create_constellation()
	game_over = false

## Entrée : Rien |
## Sortie : Rien |
## Action : Augmente le nombre de planètes  et crée la constellation du niveau composé d'autant de planètes que défini
func create_constellation() -> void :
	if planets_amount > 2 :
		timer.start(time_allowed)
	planets_amount = planets_amount * 3/2
	if planets_amount > max_planets :
		planets_amount = max_planets
		if time_allowed > minimum_time :
			time_allowed -= time_step
	constelation_required_planet_amount = planets_amount
	var coordinates = create_coordinates(planets_amount)
	for i in range(coordinates.size()):
		print("spawn planet ", i)
		spawn_planet(coordinates[i], max(coordinates[i].distance_to(coordinates[i-1]), coordinates[i].distance_to(coordinates[(i+1)%coordinates.size()])))
	connect_planets()# usefull for link clicks
	current_level += 1

## Entrée : amount un nombre flottant (float) |
## Sortie : result un une liste de vecteurs (Array[Vector2]) |
## Action : Crée autant de coordonnées que précisé en entrée et les retourne sous forme de liste |
func create_coordinates(amount : float) -> Array[Vector2] :
	var result : Array[Vector2] = []
	var rect : Rect2 = camera.get_viewport_rect()
	var current_degree = 0
	var degree_step = 360.0/amount
	var blackhole_offset = 300
	
	for i in range(amount):
		var x = cos(deg_to_rad(randf_range(current_degree-degree_step/2, current_degree+degree_step/2)))*randf_range(blackhole_offset, 625)
		var y = sin(deg_to_rad(randf_range(current_degree-degree_step/2, current_degree+degree_step/2)))*randf_range(blackhole_offset, 345)
		var rand_pos = Vector2(x, y)
		for other_planet in result :
			if rand_pos.distance_to(other_planet) < min_planet_spacing :
				#S'il faut check si les planètes sont trop proches il faut le faire ici ! :3
				pass
		
		current_degree += degree_step
		result.append(rand_pos)
	return result

## Entrée : coo un vecteur, distance max un nombre flottant
## Sortie : Rien |
## Action : Fait apparaître une planète/étoile aux coordonnées données et avec une distance de lien maximum donnée
func spawn_planet(coo : Vector2, distance_max : float = constelation_maximal_planet_distance) -> void :
	var planet_packed : PackedScene = planets_scenes.pick_random()
	var planet_node : Planet = planet_packed.instantiate()
	planets_parent.add_child(planet_node)
	planet_node.global_position = coo
	planet_node.line_max_range = distance_max
	planet_node.planet_size = (distance_max / planet_scale) + 0.6

#endregion

#region constelation link click

# LINK CLICK

func connect_planets() -> void:
	var children : Array[Planet]
	children.assign(planets_parent.get_children().filter(func(node: Node): return node is Planet) as Array[Planet])
	#if (constelation_required_all): constelation_required_planet_amount = children.size()
	for child in children:
		if (!child.planet_clicked.is_connected(start_constelator)): child.planet_clicked.connect(start_constelator)
		if (!child.planet_hovered.is_connected(join_constelator)): child.planet_hovered.connect(join_constelator)

# LINK STATE

var linking_planets : Array[Planet] = []

func is_linking() -> bool:
	return !linking_planets.is_empty()


# start a constelation with this star
func start_constelator(planet: Planet):
	if game_over :
		print_debug("trying to start a constelation but there is no time left!")
		return
	if (is_linking()):
		print_debug("trying to start a constelation but making already one!")
		return
	linking_planets = [planet]
	planet.join_constelation(linking_planets.size())


# join the current constelation in build
func join_constelator(planet: Planet):
	if (!is_linking()):
		print_debug("trying to join a constelation but not making one!")
		return
	
	var last_planet = linking_planets[linking_planets.size() - 1]
	var planet_distance = planet.position.distance_to(last_planet.position)
	if (constelation_second_distance_check && planet_distance > last_planet.line_max_range + planet.planet_size): return
	
	last_planet.constelation_link(planet)
	linking_planets.append(planet)
	planet.join_constelation(linking_planets.size())

	if (constelation_required_finish && linking_planets.size() >= constelation_required_planet_amount):
		release_constelator()


func release_constelator():
	if (linking_planets.size() >= constelation_required_planet_amount):
		print("have linked ", linking_planets.size(), " planets")
		for planet in linking_planets: planet.finish_constelation()
		start_level()
		$SFX_Confirm_Alignment.set_parameter("NumSelectedStars",planets_amount - 4)
		$SFX_Confirm_Alignment.play()
	else:
		$SFX_Unselect_Star.play()
		print("failed linking ", linking_planets.size(), " planets")
		for planet in linking_planets: planet.cancel_constelation()
	linking_planets = []
	
	

#endregion

#region Timer
func _on_timer_timeout() -> void:
	game_over = true
	timer.stop()
	print("Temps écoulé au niveau : ", current_level)
	timeout.emit()
	$CameraPhysic/Camera2D/MUSIC.set_parameter("EndGame",1)

func check_for_blackhole_sprite_change() -> void :
	var sprites = [
		"res://assets/images/chara/anim/1.png",
		"res://assets/images/chara/anim/2.png",
		"res://assets/images/chara/anim/3.png",
		"res://assets/images/chara/anim/4.png",
		"res://assets/images/chara/anim/5.png",
		"res://assets/images/chara/anim/6.png",
		"res://assets/images/chara/anim/7.png",
		"res://assets/images/chara/anim/8.png",
		"res://assets/images/chara/anim/9.png",
		"res://assets/images/chara/anim/10.png",
		"res://assets/images/chara/anim/11.png",
	]
	if int(timer.time_left/time_allowed*10) != current_sprite:
		current_sprite = int(timer.time_left/time_allowed*10)
		blackhole_sprite.texture = load(sprites[current_sprite])
#endregion
