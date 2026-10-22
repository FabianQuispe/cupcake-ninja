class_name EnemigoOruga
extends Enemigo

#Enemigo robot oruga

@onready var animacion: AnimationPlayer = $AnimationPlayer
const ESCENA_BALA := preload("res://escenas/enemigos/proyectil_oruga.tscn")

var disparo = 0
var distanciaDisparo= 200
var direccion_movimiento = 1 
var movimiento = 150  
var posicion_inicial = 0 
var ataca = false
var tiempo_espera_disparo = 3

func _ready() -> void:
	super._ready()
	vida = 1
	velocidad = 100
	posicion_inicial = position.x 
	animacion.animation_finished.connect (fin_animacion)
	animacion.play ("walk")

	
func comportamiento (_delta: float) -> void:
	if ataca:
		return

	if position.x > posicion_inicial + movimiento:
		direccion_movimiento = -1
	elif position.x < posicion_inicial - movimiento:
		direccion_movimiento = 1
	mover(Vector2(direccion_movimiento, 0))
	
#Cuando choca con una pared, el enemigo se mueve a otra dirección.
	if is_on_wall():
		direccion_movimiento = -direccion_movimiento

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
	disparar_oruga()

func disparar_oruga() -> void:
	ataca = true
	animacion.play ("attack")
	var bala = ESCENA_BALA.instantiate()
	bala.direccion = Vector2 (direccion_movimiento, 0). normalized()
	bala.objetivo = objetivo
	get_parent().add_child(bala)
	bala.global_position = global_position

func fin_animacion(tipo_animacion) -> void:
	if tipo_animacion == "attack":
		ataca = false
		animacion.play("walk")
