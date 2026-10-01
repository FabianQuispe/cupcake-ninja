class_name Enemigo
extends Personaje

var tipo: String = "Enemigo"
var objetivo: Jugador
var danio_contacto: int = 1


func _ready() -> void:
	nombre = tipo
	vida = 35
	velocidad = 42.0
	queue_redraw()

	
func _draw() -> void:
	draw_circle(Vector2.ZERO, 16.0, Color("e96868"))
	draw_circle(Vector2(-5, -3), 3.0, Color("fff0db"))
	draw_circle(Vector2(5, -3), 3.0, Color("fff0db"))
