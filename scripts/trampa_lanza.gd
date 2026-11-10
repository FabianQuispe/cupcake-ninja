class_name TrampaLanza
extends Trampa

#Trampa de lanza que se activa cada tres segundos y daña al jugador.

@onready var animacion: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
const TIEMPO_ESPERA := 3.0

var _tiempo = 0.0
var _activada = false

func activar() -> void:
	animacion.animation_finished.connect(_fin_animacion)
	sprite.frame = 0

func _physics_process(delta: float) -> void:
	if _activada:
		return
	_tiempo += delta
	if _tiempo < TIEMPO_ESPERA:
		return
	_tiempo = 0
	_activada = true
	animacion.play("trampa_activada")

#La trampa puede dañar al jugador cuando está activada.
func daniar() -> bool:
	return _activada and sprite.frame !=0
	
func _fin_animacion (tipo_animacion) -> void:
	if tipo_animacion == "trampa_activada":
		_activada = false
		sprite.frame = 0
