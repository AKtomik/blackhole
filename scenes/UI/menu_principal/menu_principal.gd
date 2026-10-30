extends Control

# Prépare les noeuds visuels à être appelés dans le code
@onready var menu_principal = $Menu_principal
@onready var menu_parametres = $Menu_parametres
@onready var musique_fond = $MusiqueFond

# Pré charge la scène
var MainScene = preload("res://scenes/space_scene.tscn").instantiate()

## Entrée : Rien |
## Sortie : Rien |
## Action : Connecte les signaux à leurs fonctions dédiées |
func _ready():
	#Signal pour quitter les paramètres
	menu_parametres.exit_parametres.connect(on_exit_parametres)
	#Signal pour quitter la scène principale
	MainScene.Quitter.connect(on_quitter)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# On ne fait rien
	pass

#region Paramètres
## Entrée : Rien |
## Sortie : Rien |
## Action : Affiche le menu des paramètres |
func _on_param_button_pressed():
	menu_principal.visible = false
	menu_parametres.set_process(true)
	menu_parametres.visible = true

## Entrée : Rien |
## Sortie : Rien |
## Action : Cache le menu des paramètres |
func on_exit_parametres() -> void :
	menu_principal.visible = true 
	menu_parametres.visible = false
	menu_parametres.set_process(false)
#endregion

## Entrée : Rien |
## Sortie : Rien |
## Action : Affiche la scène principale (et arrète les effets du menu principal |
func _on_play_button_pressed():
	
	get_tree().change_scene_to_file("res://scenes/space_scene.tscn")
	musique_fond.playing = false
	menu_principal.visible = false
	self.queue_free()

## Entrée : Rien |
## Sortie : Rien |
## Action : Quand la musique est fini, rejoue la musique |
func _on_musique_fond_finished() -> void:
	musique_fond.play()

## Entrée : Rien |
## Sortie : Rien |
## Action : Quand la scène principale est quitté, affiche correctement le menu principal, prépare la scène principale à être réutilisé, réassigne ses signaux |
func on_quitter () -> void :
	musique_fond.playing = true
	menu_principal.visible = true
	MainScene.Quitter.connect(on_quitter)
