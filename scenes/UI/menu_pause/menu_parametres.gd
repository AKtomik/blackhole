extends Control

signal exit_parametres

@onready var sound_click = $SFX_Click
@onready var sound_hover = $SFX_Hover

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_exit_button_pressed():
	exit_parametres.emit()
	set_process(false)
	sound_click.play()

func on_button_hover() -> void :
	sound_hover.play()
