extends Node2D

#Prépare l'accès aux objets dans la scène dont on a besoin
@onready var menu_parametres = $Menu_parametres

# Signal à envoyer quand on veut quitter la scène
signal Quitter()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("PAUSE") :
		on_param_button_pressed()

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
	self.set_process(false)
	menu_parametres.set_process(true)
	menu_parametres.visible = true

## Entrée : Rien |
## Sortie : Rien |
## Action : Cache le menu des paramètres |
func on_exit_parametres() -> void :
	self.set_process(true)
	menu_parametres.visible = false
	menu_parametres.set_process(false)

#endregion
