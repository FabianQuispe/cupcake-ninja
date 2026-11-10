class_name EnemigoOruga
extends Enemigo

#Enemigo robot oruga

@onready var animacion: AnimationPlayer = $AnimationPlayer
const ESCENA_BALA := preload("res://escenas/enemigos/proyectil_oruga.tscn")
const DISTANCIA_DISPARO := 200.0
const TIEMPO_ESPERA_DISPAROS := 3.0
const MOVIMIENTO := 150.0

var _disparo = 0.0
var _direccion_movimiento = 1 
var _posicion_inicial = 0.0 
var _ataca = false


func _ready() -> void:
	super._ready()
	vida = 1
	velocidad = 100
	_posicion_inicial = position.x 
	animacion.animation_finished.connect (_fin_animacion)
	animacion.play ("walk")

	
func comportamiento (delta: float) -> void:
	if _ataca:
		return
	if position.x > _posicion_inicial + MOVIMIENTO:
		_direccion_movimiento = -1
	elif position.x < _posicion_inicial - MOVIMIENTO:
		_direccion_movimiento = 1
	mover(Vector2(_direccion_movimiento, 0))
	
#Cuando choca con una pared, el enemigo se mueve a otra dirección.
	if is_on_wall():
		_direccion_movimiento = -_direccion_movimiento

	$Sprite2D.flip_h = _direccion_movimiento < 0

#Lanza la bomba si detecta al jugador cerca.
	_disparo += delta 
	if _disparo < TIEMPO_ESPERA_DISPAROS:
		return
	if not is_instance_valid(objetivo):
		return
	if global_position.distance_to(objetivo.global_position) > DISTANCIA_DISPARO:
		return
	_disparo = 0.0
	disparar()

func disparar() -> void:
	_ataca = true
	animacion.play ("attack")
	var bala = ESCENA_BALA.instantiate()
	bala.direccion = Vector2 (_direccion_movimiento, 0). normalized()
	bala.objetivo = objetivo
	get_parent().add_child(bala)
	bala.global_position = global_position

func _fin_animacion(tipo_animacion) -> void:
	if tipo_animacion == "attack":
		_ataca = false
		animacion.play("walk")
