class_name EnemigoPapa
extends Enemigo

var disparo = 0
var distanciaDisparo= 200

func _ready() -> void:
	super._ready()
	vida = 1
	velocidad = 20

func comportamiento (_delta: float) -> void:
	if not is_instance_valid(objetivo):
		return

func disparar_papa() -> void:
	var papa = ProyectilEnemigo.new()
	get_parent().add_child(papa)
	papa.global_positioin = global_position
	papa.direccion = (objetivo.global_position - global_position)
	papa.objetivo = objetivo
