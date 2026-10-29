class_name ProyectilJugador
extends Proyectil


#RECORDATORIO: AVISAR QUE EL PROYECTIL DEL JUGADOR DEBE HEREDAR DE PROYECTIL
const DISTANCIA_DISPARO := 58.0
@onready var animacion: AnimationPlayer = $AnimationPlayer

var alcance := 97.0
var _recorrido := 0.0

func _init() -> void:
	velocidad = 500.0
	danio = 1
	
func _ready() -> void:
	rotation = direccion.angle()
	animacion.play("disparar_jugador")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _phisics_process(delta: float) -> void:
	avanzar (delta)
	_recorrido += velocidad * delta

	var enemigo = _enemigo_tocado()
	if enemigo != null:
		enemigo.recibir_dano(danio)
		queue_free()
		return
	if _recorrido >= alcance:
		queue_free()

func _enemigo_tocado() -> Enemigo:
	for enemigo in get_tree().get_nodes_in_group("enemigos"):
		if enemigo.vida > 0 and global_position.distance_to(enemigo.global_position) < DISTANCIA_DISPARO:
			return enemigo
	return null
