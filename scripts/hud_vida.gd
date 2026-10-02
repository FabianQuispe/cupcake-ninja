class_name HudVida
extends Control

#Definición de recursos
@export var vida: Texture2D
@export var sin_vida:Texture2D

#Vidas como TextureRect
@export var VidaCereza1: TextureRect
@export var VidaCereza2: TextureRect
@export var VidaCereza3: TextureRect

#Muestra las vidas
func _ready() -> void:
	actualizar_vidas(3)
	
func actualizar_vidas(vida_actual:int) -> void:
	if vida_actual <0:
		actualizar_cerezas (sin_vida, sin_vida, sin_vida)
	else:
		match vida_actual:
			3: actualizar_cerezas(vida, vida,vida)
			2: actualizar_cerezas(vida, vida, sin_vida)
			1: actualizar_cerezas(vida, sin_vida, sin_vida)

func actualizar_cerezas(cereza_1, cereza_2, cereza_3) -> void:
		VidaCereza1.texture = cereza_1
		VidaCereza2.texture = cereza_2
		VidaCereza3.texture = cereza_3
	
