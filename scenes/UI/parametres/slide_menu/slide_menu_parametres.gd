extends Control

# Prépare les noeuds visuels à être appelés dans le code
@onready var nom_audio = $HBoxContainer/Nom_Audio as Label
@onready var valeur_audio = $HBoxContainer/Valeur_Audio as Label
@onready var h_slider = $HBoxContainer/HSlider as HSlider

# Permet de choisir quel bus ce slider va changer
@export_enum("Master", "Music", "Sfx") var bus_name : String

var bus_index : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	h_slider.value_changed.connect(on_value_changed)
	connect_bus_index()
	set_nom_audio()
	set_slider_value()
	

## Entrée : Rien |
## Sortie : Rien |
## Action : CHange le label pour convenir au bus changé |
func set_nom_audio () -> void : 
	match bus_name:
		"Master" :
			nom_audio.text = str("Général")
		"Music" :
			nom_audio.text = str("Musique")
		"Sfx" :
			nom_audio.text = str("Effets Sonores")

## Entrée : Rien |
## Sortie : Rien |
## Action : Change le text du label qui indique le volume |
func set_valeur_audio () -> void : 
	valeur_audio.text = str(h_slider.value * 100) + " %"

## Entrée : Rien |
## Sortie : Rien |
## Action : Change le volume de l'audio dans le bus audio |
func on_value_changed(value : float) -> void : 
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	set_valeur_audio()

## Entrée : Rien |
## Sortie : Rien |
## Action : Met le slider au bon endroit en fonction du bus |
func set_slider_value () -> void:
	h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	set_valeur_audio()

## Entrée : Rien |
## Sortie : Rien |
## Action : Récupère l'index du bus en fonction du paramètre d'entrée |
func connect_bus_index () -> void : 
	bus_index = AudioServer.get_bus_index(bus_name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
