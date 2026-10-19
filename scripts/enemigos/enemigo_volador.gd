class_name EnemigoVolador
extends Enemigo

var disparo = 0
var distanciaDisparo= 250
var direccion_movimiento = 1 
var movimiento = 200  
var posicion_inicial = 0 

func _ready() -> void:
	super._ready()
	vida = 2
	velocidad = 80

#RECORDATORIO: DEBO CONTINUAR CON EL ENEMIGO VOLADOR, Y DEBO HACER EL CODIGO DE LAS PLATAFORMAS
func comportamiento (_delta: float) -> void:
	if position.x > posicion_inicial + movimiento:
		direccion_movimiento = -1
	elif position.x < posicion_inicial - movimiento:
		direccion_movimiento = 1
	mover(Vector2(direccion_movimiento, 0))
	$Sprite2D.flip_h = direccion_movimiento < 0
