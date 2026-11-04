class_name ProyectilJugador
extends Proyectil


const DISTANCIA_DISPARO := 58.0
@onready var animacion: AnimationPlayer = $AnimationPlayer

var alcance_max:= 240.0
var _recorrido := 0.0

func _init() -> void:
	velocidad = 500.0
	danio = 1

#animación cuando el jugador lanza el proyectil.
func _ready() -> void:
	rotation = direccion.angle()
	animacion.play("disparar_jugador")


func _physics_process(delta: float) -> void:
	avanzar (delta)
	var enemigo := _enemigo_tocado()
	if enemigo != null:
		enemigo.recibir_dano(enemigo.vida)
		queue_free()
		return
	if topar_proyectil_pared(delta):
		queue_free()
		return
	if position.x <0 or position.x > 1152 or position.y > 648 or position.y <0:
		queue_free()


func _enemigo_tocado() -> Enemigo:
	for enemigo in get_tree().get_nodes_in_group("enemigos"):
		if enemigo.vida > 0 and global_position.distance_to(enemigo.global_position) < 35:
			return enemigo
	return null
