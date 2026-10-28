class_name PowerUpVida
extends PowerUp

var cantidad_vidas: int = 3

#El power up de la vida aparece en un dropeo cuando el jugador mata a un enemigo.

func aplicar_vida(jugador: Jugador) -> void:
	jugador.vida += cantidad_vidas
	jugador.vida_cambiada.emit(jugador.vida)


func usar(jugador: Jugador) -> void:
	aplicar_vida(jugador)
