class_name EnemigoPapa
extends Enemigo

@onready var animacion: AnimationPlayer = $AnimationPlayer

var disparo = 0
var distanciaDisparo= 200
var direccion_movimiento = 1 
var movimiento = 150  
var posicion_inicial = 0 
var ataca = false
var tiempo_espera_disparo = 10

func _ready() -> void:
	super._ready()
	vida = 1
	velocidad = 100
	posicion_inicial = position.x 
	animacion.animation_finished.connect (fin_animacion)#nuevo
	animacion.play ("walk") #nuevo
	
func comportamiento (_delta: float) -> void:
	if ataca:
		return
		
	if position.x > posicion_inicial + movimiento:
		direccion_movimiento = -1
	elif position.x < posicion_inicial - movimiento:
		direccion_movimiento = 1
	mover(Vector2(direccion_movimiento, 0))
	$Sprite2D.flip_h = direccion_movimiento < 0
	
	disparo += _delta #NUEVOO
	if disparo < tiempo_espera_disparo:
		return
	elif not is_instance_valid(objetivo):
		return
	var distancia = global_position.distance_to(objetivo.global_position)
	if distancia > distanciaDisparo:
		return
	disparo=0
	disparar_papa()

func disparar_papa() -> void:
	ataca = true
	animacion.play ("attack")
	var papa = ProyectilEnemigo.new()
	get_parent().add_child(papa)
	papa.global_position = global_position
	papa.direccion = (objetivo.global_position - global_position)
	papa.objetivo = objetivo

func fin_animacion(tipo_animacion) -> void:
	if tipo_animacion == "attack":
		ataca = false
		animacion.play("walk")
