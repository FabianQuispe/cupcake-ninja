class_name PowerUp
extends Node2D

#Clase base del power up de vida y escudo.

var duracion_power_up: float = 5.0
var aparicion := true

func _ready() -> void:
	add_to_group("power_ups")

func obtener(jugador: Jugador) -> void:
	jugador.power_up_disponible = self
	aparicion = false
	visible = false
	set_process(false)

func usar(_jugador: Jugador) -> void:
	pass
