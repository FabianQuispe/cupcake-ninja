class_name TrampaLanza
extends Trampa

#Trampa de lanza que se activa cada tres segundos y daña al jugador.

@onready var animacion: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

var tiempo = 0.0
var tiempo_espera = 3
var activada = false

func activar() -> void:
	animacion.animation_finished.connect(fin_animacion)
	sprite.frame = 0

func _physics_process(delta: float) -> void:
	if activada:
		return
	tiempo += delta
	if tiempo < tiempo_espera:
		return
	tiempo = 0
	activada = true
	animacion.play("trampa_activada")

#La trampa puede dañar al jugador cuando está activada.
func daniar() -> bool:
	return activada and sprite.frame !=0
	
func fin_animacion (tipo_animacion) -> void:
	if tipo_animacion == "trampa_activada":
		activada = false
		sprite.frame = 0
