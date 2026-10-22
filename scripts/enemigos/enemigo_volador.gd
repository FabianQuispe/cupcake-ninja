class_name EnemigoVolador
extends Enemigo

#Este enemigo vuela y lanza bombas desde abajo.

@onready var sprite: Sprite2D = $Sprite2D
@onready var animacion: AnimationPlayer = $AnimationPlayer
const ESCENA_BOMBA:= preload ("res://escenas/enemigos/proyectil_enemigo_volador.tscn")

var disparo = 0.0
var tiempo_espera_disparo = 5
var distanciaDisparo= 250
var direccion_movimiento = 1 
var movimiento = 200  
var posicion_inicial = 0.0
var lanzar = false

func _ready() -> void:
	super._ready()
	vida = 2
	velocidad = 80
	posicion_inicial = position.x
	sprite.frame = 0
	animacion.animation_finished.connect(fin_animacion)
	
	
func comportamiento (_delta: float) -> void:
#Se queda quieto mientras el enemigo vuela.
	if lanzar:
		return 

#El enemigo se mueve de izquierda a derecha.
	if position.x > posicion_inicial + movimiento:
		direccion_movimiento = -1
	elif position.x < posicion_inicial - movimiento:
		direccion_movimiento = 1
	mover(Vector2(direccion_movimiento, 0))
	
	#Cuando choca con una pared, el enemigo se mueve a otra dirección.
	if is_on_wall():
		direccion_movimiento = -direccion_movimiento
	
	#El sprite se da vuelta a la direccion donde vuela.
	$Sprite2D.flip_h = direccion_movimiento < 0 

#Lanza la bomba si detecta al jugador cerca.
	disparo += _delta 
	if disparo < tiempo_espera_disparo:
		return
	elif not is_instance_valid(objetivo):
		return
	var distancia = global_position.distance_to(objetivo.global_position)
	if distancia > distanciaDisparo:
		return
	disparo=0
	disparar()

func disparar() -> void:
	lanzar = true
	animacion.play ("lanzar_bomba")
	var bomba = ESCENA_BOMBA.instantiate()
	bomba.direccion = Vector2.DOWN
	bomba.objetivo = objetivo
	get_parent().add_child(bomba)
	bomba.global_position = global_position

func fin_animacion(tipo_animacion) -> void:
	if tipo_animacion == "lanzar_bomba":
		lanzar = false
		sprite.frame=0
