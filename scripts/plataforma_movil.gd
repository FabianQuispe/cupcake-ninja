class_name PlataformaMovil
extends Plataforma

#Esta plataforma se mueve de arriba a abajo e izquierda a derecha.

@export var recorrido := Vector2 (150,0)
@export var velocidad_movimiento := 100
@onready var zona: Area2D = $Zona

var _posicion_iniciar: Vector2
var _posicion_finalizar: Vector2
var _direccion :=1

func _ready() -> void:
	super._ready()
	zona.collision_layer = 0
	_posicion_iniciar = position
	_posicion_finalizar = position + recorrido

func actualizar(delta: float) -> void:
	var posicion_anterior := position
	var objetivo := _posicion_finalizar
	if _direccion == -1:
		objetivo = _posicion_iniciar
	position = position.move_toward(objetivo, velocidad_movimiento * delta)
	if position == objetivo:
		_direccion = -_direccion
	var mover := position - posicion_anterior
	mover_jugador(mover)

func mover_jugador(mover: Vector2) -> void:
	for cuerpo in zona.get_overlapping_bodies():
		if cuerpo is Jugador and cuerpo.estado == Jugador.Estado.IDLE:
			cuerpo.move_and_collide(mover)
