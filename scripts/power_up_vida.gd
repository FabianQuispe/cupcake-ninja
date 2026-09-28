class_name PowerUpVida
extends PowerUp

var cantidad_vidas: int = 20


func aplicar_vida(jugador: Jugador) -> void:
	jugador.vida += cantidad_vidas
	jugador.vida_cambiada.emit(jugador.vida)


func usar(jugador: Jugador) -> void:
	aplicar_vida(jugador)
