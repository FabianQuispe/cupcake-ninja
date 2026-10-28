class_name PlataformaSalto
extends Plataforma

#Esta plataforma hace que el jugador brinque cuando entra en contacto de éste.
@onready var animacion: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var zona: Area2D = $Zona

var tiempo_saltar := 0.0

func _ready() -> void:
	super._ready()
	zona.collision_layer = 0
	await $AnimationPlayer.animation_finished #RECORDATORIO: Mejorar esta parte, la animacion se sigue activando.
	animacion.animation_finished.connect(plataforma_sin_lanzar)

func actualizar(delta: float) -> void:
	tiempo_saltar = maxf(tiempo_saltar - delta, 0.0)
	if tiempo_saltar > 0.0:
		return

#Si el cuerpo es el jugador, lo lanza, si es el enemigo no.
	for cuerpo_jugador in zona.get_overlapping_bodies():
		if cuerpo_jugador is Jugador and cuerpo_jugador.estado == Jugador.Estado.IDLE:
			lanzar(cuerpo_jugador)

#Lanza al jugador en dirección contraria.
func lanzar (jugador: Jugador) -> void:
	var direccion_saltar := Vector2.UP.rotated(global_rotation).round()
	jugador.iniciar_deslizamiento(direccion_saltar)
	if jugador.estado != Jugador.Estado.SLIDING:
		return
	tiempo_saltar = 2.0
	animacion.play("lanzar_jugador")


#Solo se muestra el primer frame cuando no toca al jugador.
func plataforma_sin_lanzar(_animacion_nombre) -> void:
	sprite.frame=0
