extends Node2D

#Prépare l'accès aux objets dans la scène dont on a besoin
@onready var menu_parametres = $CanvasLayer/Menu_parametres
@onready var planets = $Planets
@onready var game_over = $CanvasLayer/Game_over

# Signal à envoyer quand on veut quitter la scène
signal Quitter()

#Necessary things for the animation/transition
var sample_point := 0.0
@export var growth_curve : Curve
@export var growth_speed := 1.0
@onready var black_hole = $BlackHole
@onready var Parralax = $ParralaxManager
@onready var CameraPhysic = $BlackHole/CameraPhysic
var growing := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	growth_anim(8.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("PAUSE"):
		on_param_button_pressed()

func growth_anim(time):
	growing = true
	Parralax.growth_anim(time)
	await CameraPhysic.growth_anim(time)
	growing = false
	black_hole.scale = Vector2(1.0, 1.0)

func _physics_process(delta: float) -> void:
	if growing :
		sample_point += (delta * growth_speed)
		black_hole.scale.x = growth_curve.sample(sample_point) ; black_hole.scale.y = growth_curve.sample(sample_point)
	else :
		sample_point = 0.0

## Entrée : Rien |
## Sortie : Rien |
## Action : Envoie le signal que la scène a été quittée et détruit la scène |
func quitter_scene() -> void:
	Quitter.emit()
	queue_free()

#region paramètres

## Entrée : Rien |
## Sortie : Rien |
## Action : Affiche le menu des paramètres |
func on_param_button_pressed():
	%BlackHole.paused(true)
	self.set_process(false)
	menu_parametres.set_process(true)
	menu_parametres.visible = true

## Entrée : Rien |
## Sortie : Rien |
## Action : Cache le menu des paramètres |
func on_exit_parametres() -> void :
	self.set_process(true)
	%BlackHole.paused(false)
	menu_parametres.visible = false
	menu_parametres.set_process(false)

#endregion


func _on_black_hole_timeout() -> void:
	game_over.visible = true


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/menu_principal/menu_principal.tscn")
	self.queue_free()
