extends Parallax2D
@export var Stars_Patern : Texture
var base_opacity := 1.0
var base_scale := 1.0
var dontModif := false

func _ready() -> void:
	$Sprite2D.texture = Stars_Patern
