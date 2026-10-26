class_name TrampaShuriken
extends Trampa

#Trampa que gira y daña al jugador cuando es tocado.
@onready var animacion: AnimationPlayer = $AnimationPlayer

func activar() -> void:
#Bucle de la animación de la trampa.
	animacion.get_animation("shuriken_activo").loop_mode = Animation.LOOP_LINEAR
	animacion.play("shuriken_activo")

#El shuriken dañará siempre.
func daniar() -> bool:
	return true
