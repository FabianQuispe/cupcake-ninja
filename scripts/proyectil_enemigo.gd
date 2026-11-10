class_name ProyectilEnemigo
extends Proyectil

var objetivo: Jugador

func _init() -> void:
	velocidad = 200
	danio = 1

func _ready() -> void:
	rotation = direccion.angle()
	$Bala.flip_v = direccion.x <0

func _physics_process(delta: float) -> void:
	avanzar(delta)

#Sí el enemigo está a una distancia menor de 20 del jugador, lo detecta y le lanza una bala.
	if is_instance_valid(objetivo) and global_position.distance_to(objetivo.global_position) < 20:
		objetivo.recibir_dano(danio)
		queue_free()
		return

#Si el proyectil choca con una pared, o cualquier asset que no sea el jugador, éste se elimina del mapa.
	if topar_proyectil_pared (delta):
		queue_free()
		return

	if position.x <0 or position.x > 1152 or position.y > 648 or position.y <0:
		queue_free()
