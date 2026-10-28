class_name PowerUpEscudo
extends PowerUp

var escudo := false
var aparicion := true
#El escudo está desde el inicio en el mapa, se puede usar mientras el jugador lo tenga y lo active.

func activar_escudo(jugador: Jugador) -> void:
	escudo = true
	jugador.activar_escudo(duracion_power_up)


func desactivar_escudo(jugador: Jugador) -> void:
	escudo = false
	jugador.escudo_activo = false
	jugador.queue_redraw()

func obtener(jugador: Jugador) -> void:
	jugador.power_up_disponible = self
	aparicion = false
	visible = false
	set_process(false)

func usar(jugador: Jugador) -> void:
	activar_escudo(jugador)
	queue_free()
