class_name HudVida
extends Control

#Definición de recursos
@export var vida: Texture2D
@export var sin_vida:Texture2D

#Vidas como TextureRect
@export var VidaCorazon1: TextureRect
@export var VidaCorazon2: TextureRect
@export var VidaCorazon3: TextureRect

#Muestra las vidas
func _ready() -> void:
	actualizar_vidas(3)

func actualizar_vidas(vida_actual:int) -> void:
	if vida_actual <0:
		actualizar_corazon (sin_vida, sin_vida, sin_vida)
	else:
		match vida_actual:
			3: actualizar_corazon(vida, vida,vida)
			2: actualizar_corazon(vida, vida, sin_vida)
			1: actualizar_corazon(vida, sin_vida, sin_vida)

func actualizar_corazon(corazon_1, corazon_2, corazon_3) -> void:
		VidaCorazon1.texture = corazon_1
		VidaCorazon2.texture = corazon_2
		VidaCorazon3.texture = corazon_3
