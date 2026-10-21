class_name PlataformaMovil
extends Plataforma

#Esta plataforma se mueve de arriba a abajo e izquierda a derecha.

@export var recorrido :=Vector2 (150,0)
@export var velocidad_movimiento := 50

var posicion_iniciar: Vector2
var posicion_finalizar: Vector2
var direccion :=1

func _ready() -> void:
	super._ready()
	posicion_iniciar = position
	posicion_finalizar = position + recorrido

func actualizar(delta: float) -> void:
	var objetivo := posicion_finalizar
	if direccion == -1:
		objetivo = posicion_iniciar
	position = position.move_toward(objetivo, velocidad_movimiento * delta)
	if position == objetivo:
		direccion = -direccion
