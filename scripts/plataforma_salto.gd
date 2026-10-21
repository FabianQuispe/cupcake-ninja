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
	animacion.animacion_finished.connect(plataforma_sin_lanzar)
	
func actualizar(delta: float) -> void:
	tiempo_saltar = maxf(tiempo_saltar - delta, 0.0)
	if tiempo_saltar > 0:
		return
	
#Si el cuerpo es el jugador, lo lanza, si es el enemigo no.
	for cuerpo_jugador in zona.get_overlapping_bodies():
		if cuerpo_jugador is Jugador:
			lanzar (cuerpo_jugador)

#Lanza al jugador.
func lanzar (jugador: Jugador) -> void:
	tiempo_saltar = 2
	animacion.play("lanzar_jugador")
	jugador.iniciar_deslizamiento(Vector2.UP)

#Solo se muestra el primer frame cuando no toca al jugador.
func plataforma_sin_lanzar(_animacion_nombre) -> void:
	sprite.frame=0
