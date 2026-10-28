class_name Assigner_Bouton
extends Control

#Prépare l'accès aux objets dans la scène dont on a besoin
@onready var label = $HBoxContainer/Label as Label
@onready var button = $HBoxContainer/Button as Button

#La scène a comme paramètre personnalisé l'action qu'on souhaite changer (par défaut "BOUGER_HAUT")
#Ces paramètres personalisés sont modifiables dans Projet -> PAramètres du projet -> Contrôles
@export var nom_action : String = "BOUGER_HAUT"


@onready var nom_touche : String = OS.get_keycode_string(InputMap.action_get_events(nom_action)[0].physical_keycode)


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_unhandled_key_input(false)
	set_texte_label()
	set_texte_bouton()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## Entrée : Rien |
## Sortie : Rien |
## Action : Change le texte de l'action pour être celle sélectionnée |
func set_texte_label() -> void : 
	label.text = "Non assignée"
	
	match nom_action :
		"BOUGER_HAUT":
			label.text = "monter"
		"BOUGER_BAS":
			label.text = "descendre"
		"BOUGER_DROITE":
			label.text = "aller à droite"
		"BOUGER_GAUCHE":
			label.text = "aller à gauche"
		"PAUSE":
			label.text = "Pause"

## Entrée : Rien |
## Sortie : Rien |
## Action : Change le texte du bouton pour la touche associée à l'action |
func set_texte_bouton() -> void:
	nom_touche = OS.get_keycode_string(InputMap.action_get_events(nom_action)[0].physical_keycode)
	button.text = "%s" % nom_touche

## Entrée : touche un InputEvent |
## Sortie : Rien |
## Action : Défini une nouvelle touche pour une action, et échange si elle était déjà une action |
func definir_touche(touche: InputEvent)-> void:
	#On sauvegarde l'ancienne s'il y a besoin de l'échanger
	var old = InputMap.action_get_events(nom_action)[0]
	var action_keycode=touche.physical_keycode
	
	#On supprime l'inpout pour en mettre une nouvelle (et on change l'affichage en conséquence)
	InputMap.action_erase_events(nom_action)
	InputMap.action_add_event(nom_action, touche)
	set_texte_bouton()
	
	#On vérifie s'il y a besoin d'en changer une autre, au quel cas on le fait
	for i in get_tree().get_nodes_in_group("changer_touches"):
		if i.nom_action != self.nom_action and i.nom_touche==self.nom_touche :
			InputMap.action_erase_events(i.nom_action)
			InputMap.action_add_event(i.nom_action, old)
			i.set_texte_bouton()

## Entrée : Rien |
## Sortie : Rien |
## Action : Écoute la prochaine touche pressée (et le montre) |
func _on_button_pressed():
	button.text = "Appuyez sur une touche..."
	set_process_unhandled_key_input(true)

## Entrée : Event (touche pressée) |
## Sortie : Rien |
## Action : Défini la prochaine touche pressée comme controlant l'action assignée |
func _unhandled_key_input(event):
	definir_touche(event)
	set_process_unhandled_key_input(false)

## Entrée : Rien |
## Sortie : Rien |
## Action : Si on cache le bouton, on souhaite qu'il arrête de prendre les entrées de touches, et on veut que le texte reste le bon |
func _on_hidden():
	set_process_unhandled_key_input(false)
	set_texte_bouton()
