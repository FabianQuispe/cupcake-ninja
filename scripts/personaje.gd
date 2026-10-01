class_name Personaje
extends CharacterBody2D

signal vida_cambiada(vida_actual: int)

var nombre: String = "Personaje"
var vida: int = 3
var velocidad: float = 220.0
var danio_disparo: int = 1


func mover(direccion: Vector2) -> void:
	velocity = direccion.normalized() * velocidad
	move_and_slide()
	position.x = clampf(position.x, 50.0, 1102.0)
	position.y = clampf(position.y, 120.0, 600.0)


func disparar() -> void:
	pass


func recibir_dano(cantidad: int) -> void:
	vida = maxi(vida - maxi(cantidad, 0), 0)
	vida_cambiada.emit(vida)
	queue_redraw()


func _draw() -> void:
	draw_circle(Vector2.ZERO, 18.0, Color("f0b35a"))
