class_name ProyectilEnemigo
extends Proyectil

var objetivo: Jugador

func _init() -> void:
	velocidad = 200
	danio = 1

func _physics_process(delta: float) -> void:
	avanzar(delta)
	
	if is_instance_valid(objetivo) and global_position.distance_to(objetivo.global_position) < 20:
		objetivo.recibir_dano(danio)
		queue_free()
		return
	
func _draw() -> void:
	draw_circle(Vector2.ZERO, 5.0, Color("fff0a8"))
