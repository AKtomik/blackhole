extends Control

signal exit_parametres

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_exit_button_pressed():
	FmodServer.play_one_shot("SFX_Click")
	exit_parametres.emit()
	set_process(false)
