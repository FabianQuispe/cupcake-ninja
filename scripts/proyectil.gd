class_name Proyectil
extends Node2D

var direccion := Vector2.RIGHT
var velocidad := 520.0
var danio := 1


func avanzar(delta: float) -> void:
	position += direccion * velocidad * delta


func _draw() -> void:
	draw_circle(Vector2.ZERO, 5.0, Color("fff0a8"))
