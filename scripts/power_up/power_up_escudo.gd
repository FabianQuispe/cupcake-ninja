class_name PowerUpEscudo
extends PowerUp

var escudo := false


func activar_escudo(jugador: Jugador) -> void:
	escudo = true
	jugador.activar_escudo(duracion_power_up)


func desactivar_escudo(jugador: Jugador) -> void:
	escudo = false
	jugador.escudo_activo = false
	jugador.queue_redraw()


func usar(jugador: Jugador) -> void:
	activar_escudo(jugador)
