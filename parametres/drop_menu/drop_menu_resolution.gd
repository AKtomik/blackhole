extends Control

@onready var option_button = $HBoxContainer/OptionButton as OptionButton

const RESOLUTION_DICT : Dictionary = {
	"1152 x 648" : Vector2i(1152, 648),
	"1280 x 720" : Vector2i(1280, 720),
	"1920 x 1080" : Vector2i(1920, 1080),
}

# Called when the node enters the scene tree for the first time.
func _ready():
	add_resolution_items()
	option_button.item_selected.connect(on_resolution_selected)
	set_default_status()

func set_default_status() -> void : 
	if DisplayServer.window_get_size() == Vector2i(1280, 720) :
		option_button.select(1)
	elif DisplayServer.window_get_size() == Vector2i(1920, 1080):
		option_button.select(2)
	else : 
		option_button.select(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_resolution_items() -> void:
	for resolution in RESOLUTION_DICT:
		option_button.add_item(resolution)

func on_resolution_selected (index : int) -> void :
	DisplayServer.window_set_size(RESOLUTION_DICT.values()[index])
