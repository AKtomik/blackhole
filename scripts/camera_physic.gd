extends CharacterBody2D
@export var BaseSPEED := 10.0
var destination := Vector2.ZERO
var mouse_real_position := Vector2.ZERO
var black_hole_expanding := false
@export var camera_attraction_toward_center := 8.0
#Defini le centre et les limites du viewport dans l'espace de jeu.
@onready var viewport_center: Vector2 = get_viewport().get_visible_rect().get_center()
@onready var viewport_left_border := get_viewport().get_visible_rect().size.x / -2.0
@onready var viewport_right_border := get_viewport().get_visible_rect().size.x / 2.0
@onready var viewport_up_border := get_viewport().get_visible_rect().size.y / -2.0
@onready var viewport_down_border := get_viewport().get_visible_rect().size.y / 2.0


func _physics_process(delta: float) -> void:
	#Défini la posiition de la souris relative à l'espace de jeu
	mouse_real_position = get_viewport().get_mouse_position() - global_position - viewport_center
	if mouse_real_position.x < viewport_left_border :
		mouse_real_position.x = viewport_left_border
	if mouse_real_position.x > viewport_right_border :
		mouse_real_position.x = viewport_right_border
	if mouse_real_position.y < viewport_up_border :
		mouse_real_position.y = viewport_up_border
	if mouse_real_position.y > viewport_down_border :
		mouse_real_position.y = viewport_down_border
	
	#Si l'animation d'expansion du trou noir est en cours, on désactive le déplacement dynamique de 
	# la caméra, en la renvoyant vers l'origine.
	if black_hole_expanding :
		destination = Vector2.ZERO
	else :
		destination = (global_position + mouse_real_position) / camera_attraction_toward_center
	#On déplace la caméra avec un lerp.
	global_position = global_position.lerp(destination, BaseSPEED * delta)


##Met à jour les variables liées au viewport (à l'exception de la position de la souris) |
##À appeler après augmentation de la taille du trou noir
func update_viewport() : 
	viewport_center = get_viewport().get_visible_rect().get_center()
	viewport_left_border = get_viewport().get_visible_rect().size.x / -2.0
	viewport_right_border = get_viewport().get_visible_rect().size.x / 2.0
	viewport_up_border = get_viewport().get_visible_rect().size.y / -2.0
	viewport_down_border = get_viewport().get_visible_rect().size.y / 2.0
