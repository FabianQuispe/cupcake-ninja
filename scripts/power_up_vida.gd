class_name PowerUpVida
extends PowerUp

var cantidad_vidas: int = 1
const VIDA_MAX := 3
#El power up de la vida aparece en un dropeo cuando el jugador mata a un enemigo.

func aplicar_vida(jugador: Jugador) -> void:
	jugador.vida = mini(jugador.vida + cantidad_vidas, VIDA_MAX)
	jugador.vida_cambiada.emit(jugador.vida)

func obtener(jugador: Jugador) -> void:
	_aparicion = false
	if jugador.vida < VIDA_MAX:
		aplicar_vida(jugador)
	queue_free()

func usar(jugador: Jugador) -> void:
	aplicar_vida(jugador)
	queue_free()
