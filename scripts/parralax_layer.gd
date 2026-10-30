extends Parallax2D
@export var Stars_Patern : Texture

func _ready() -> void:
	$Sprite2D.texture = Stars_Patern
