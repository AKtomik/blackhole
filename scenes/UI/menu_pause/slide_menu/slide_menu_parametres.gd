extends Control

# Prépare les noeuds visuels à être appelés dans le code
@onready var nom_audio = $HBoxContainer/Nom_Audio as Label
@onready var valeur_audio = $HBoxContainer/Valeur_Audio as Label
@onready var h_slider = $HBoxContainer/HSlider as HSlider

# Permet de choisir quel bus ce slider va changer
@export_enum("Master_Level", "Music_Level", "SFX_Level") var bus_name : String


# Called when the node enters the scene tree for the first time.
func _ready():
	h_slider.value_changed.connect(on_value_changed)
	set_nom_audio()
	set_slider_value()
	

## Entrée : Rien |
## Sortie : Rien |
## Action : CHange le label pour convenir au bus changé |
func set_nom_audio () -> void : 
	match bus_name:
		"Master_Level" :
			nom_audio.text = str("Général")
		"Music_Level" :
			nom_audio.text = str("Musique")
		"SFX_Level" :
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
	FmodServer.set_global_parameter_by_name(bus_name, value*100	)
	set_valeur_audio()

## Entrée : Rien |
## Sortie : Rien |
## Action : Met le slider au bon endroit en fonction du bus |
func set_slider_value () -> void:
	h_slider.value = FmodServer.get_global_parameter_by_name(bus_name)/100
	set_valeur_audio()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
