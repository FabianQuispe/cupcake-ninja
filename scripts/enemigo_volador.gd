class_name EnemigoVolador
extends Enemigo

#Este enemigo vuela y lanza bombas desde abajo.

@onready var sprite: Sprite2D = $Sprite2D
@onready var animacion: AnimationPlayer = $AnimationPlayer
const ESCENA_BOMBA:= preload ("res://escenas/enemigos/proyectil_enemigo_volador.tscn")
const DISTANCIA_DISPARO := 250.0
const TIEMPO_ESPERA_DISPAROS := 5.0
const MOVIMIENTO := 200.0

var _disparo = 0.0
var _direccion_movimiento = 1 
var _posicion_inicial = 0.0
var _lanzar = false

func _ready() -> void:
	super._ready()
	vida = 2
	velocidad = 80
	_posicion_inicial = position.x
	sprite.frame = 0
	animacion.animation_finished.connect(_fin_animacion)
	
	
func comportamiento (delta: float) -> void:
#Se queda quieto mientras el enemigo vuela.
	if _lanzar:
		return 

#El enemigo se mueve de izquierda a derecha.
	if position.x > _posicion_inicial + MOVIMIENTO:
		_direccion_movimiento = -1
	elif position.x < _posicion_inicial - MOVIMIENTO:
		_direccion_movimiento = 1
	mover(Vector2(_direccion_movimiento, 0))
	
	#Cuando choca con una pared, el enemigo se mueve a otra dirección.
	if is_on_wall():
		_direccion_movimiento = -_direccion_movimiento
	
	#El sprite se da vuelta a la direccion donde vuela.
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
	_lanzar = true
	animacion.play ("lanzar_bomba")
	var bomba = ESCENA_BOMBA.instantiate()
	bomba.direccion = Vector2.DOWN
	bomba.objetivo = objetivo
	get_parent().add_child(bomba)
	bomba.global_position = global_position

func _fin_animacion(tipo_animacion) -> void:
	if tipo_animacion == "lanzar_bomba":
		_lanzar = false
		sprite.frame=0
