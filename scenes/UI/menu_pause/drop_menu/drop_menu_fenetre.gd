extends Control

@onready var option_button = $HBoxContainer/OptionButton as OptionButton

const MODE_FENETRE_LISTE : Array[String] = [
	"Plein écran",
	"Fenetré",
	"Fenetré sans bordure",
	"Plein écran sans bordure"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	add_window_mode_items()
	option_button.item_selected.connect(on_window_mode_selected)
	set_default_status()
	

func set_default_status() -> void : 
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED :
		if DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS) :
			option_button.select(2)
		else : 
			option_button.select(1)
	else :
		if DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS) :
			option_button.select(3)
		else : 
			option_button.select(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_window_mode_items() -> void:
	for mode_fenetre in MODE_FENETRE_LISTE:
		option_button.add_item(mode_fenetre)

func on_window_mode_selected (index : int) -> void :
	match index:
		0:  #Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1:  #Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2: #Windowed Borderless
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		3: #Fullscreen Borderless
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
