class_name Trampa
extends Node2D

var danio: int = 10
var activada := false


func recibir_dano(cantidad: int) -> void:
	if cantidad > 10:
		explotar()


func explotar() -> void:
	activada = true
	queue_redraw()


func _draw() -> void:
	var color := Color("ffbd69") if not activada else Color("f05d5e")
	draw_rect(Rect2(-16, -16, 32, 32), color)
	draw_line(Vector2(-10, -10), Vector2(10, 10), Color("182338"), 3.0)
	draw_line(Vector2(10, -10), Vector2(-10, 10), Color("182338"), 3.0)