class_name Enemigo
extends Personaje

var tipo: String = "Enemigo"
var objetivo: Jugador
var danio_contacto: int = 1

func _ready() -> void:
	nombre = tipo
	vida = 35
	velocidad = 42.0
	add_to_group("enemigos")
	queue_redraw()

func _physics_process(delta: float) -> void:
	comportamiento(delta)
	
func comportamiento (_delta: float) -> void:
	if not is_instance_valid(objetivo):
		return
	mover (objetivo.global_position - global_position)
