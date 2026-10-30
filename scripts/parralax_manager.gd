extends Node2D
@export var LayerScene : PackedScene
@export var ATextureList : Array[Texture]
@export var BTextureList : Array[Texture]
@export var CTextureList : Array[Texture]
@export var DTextureList : Array[Texture]
@onready var TextureTab := [ATextureList,BTextureList,CTextureList,DTextureList]
var LayerInstance
var UsedList = 0
var indiceTexture = 0

func _ready() -> void:
	for i in range(8, 1, -2) :
		LayerInstance = LayerScene.instantiate()
		LayerInstance.Stars_Patern = TextureTab[UsedList][indiceTexture]
		LayerInstance.scroll_scale = Vector2(float(i)/10.0,float(i)/10.0)
		LayerInstance.scale = Vector2(float(i)/10.0,float(i)/10.0)
		LayerInstance.modulate.a = float(i)/10.0
		add_child(LayerInstance)
		indiceTexture += 1
		
