extends Node2D
@export var LayerScene : PackedScene
@export var ATextureList : Array[Texture]
@export var BTextureList : Array[Texture]
@export var CTextureList : Array[Texture]
@export var DTextureList : Array[Texture]
@export var OpacityCurve : Curve
@export var opacity_speed := 1.0
@onready var TextureTab := [ATextureList,BTextureList,CTextureList,DTextureList]
var CameraIsMoving := false
var sample_point := 0.0
var newLayerAdded := false
var LayerInstance
var UsedList = 0
var indiceTexture = 0

func _ready() -> void:
	for i in range(4, 0, -1) :
		LayerInstance = LayerScene.instantiate()
		LayerInstance.Stars_Patern = TextureTab[UsedList][indiceTexture]
		LayerInstance.scroll_scale = Vector2(i * 0.2, i * 0.2)
		LayerInstance.scale = Vector2(i * 0.2, i * 0.2)
		LayerInstance.modulate.a = i / 4.0
		LayerInstance.base_opacity = LayerInstance.modulate.a
		LayerInstance.base_scale = LayerInstance.scroll_scale.x
		add_child(LayerInstance)
		indiceTexture += 1
	indiceTexture = 0

func growth_anim(time):
	CameraIsMoving = true
	await get_tree().create_timer(time).timeout
	CameraIsMoving = false
	newLayerAdded = false
	sample_point = 0.0
	scale /= 2.5
	for Child in get_children() :
		Child.base_opacity = Child.modulate.a
		Child.base_scale = Child.scroll_scale.x
		if Child.dontModif == true :
			Child.dontModif = false
		if Child.base_opacity <= 0.1 :
			Child.queue_free()

	

func _physics_process(delta: float) -> void:
	if CameraIsMoving :
		sample_point += (delta * opacity_speed)
		for Child in get_children() :
				Child.modulate.a = Child.base_opacity - (OpacityCurve.sample(sample_point) * 0.25)
	if sample_point >= 4.25 and not newLayerAdded :
		newLayerAdded = true
		LayerInstance = LayerScene.instantiate()
		LayerInstance.Stars_Patern = TextureTab[UsedList][indiceTexture]
		LayerInstance.scroll_scale = Vector2(1.2 - (OpacityCurve.sample(sample_point) * 0.2), 1.2 - (OpacityCurve.sample(sample_point) * 0.2))
		LayerInstance.scale = Vector2(0.8, 0.8)
		LayerInstance.modulate.a = 1.0
		LayerInstance.dontModif = true
		add_child(LayerInstance)
		indiceTexture += 1
		if indiceTexture == 4 :
			indiceTexture = 0
		
