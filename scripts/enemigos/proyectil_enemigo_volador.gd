class_name ProyectilEnemigoVolador
extends Proyectil
@onready var animacion: AnimationPlayer = $AnimationPlayer

var objetivo: Jugador

func _init() -> void:
	velocidad = 300
	danio = 1

func _ready() -> void:
#Se reproduce la animación cuando lanza la bomba el enemigo.
	animacion.play("lanzar_bomba")

func _physics_process(delta: float) -> void:
	avanzar(delta)

	if is_instance_valid(objetivo) and global_position.distance_to(objetivo.global_position) < 20:
		objetivo.recibir_dano(danio)
		queue_free()
		return

	if position.x <0 or position.x > 1152 or position.y > 648 or position.y <0:
		queue_free()
