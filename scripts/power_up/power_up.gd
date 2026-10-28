class_name PowerUp
extends Node2D

#Clase base del power up de vida y escudo.

var duracion_power_up: float = 5.0

func _ready() -> void:
	add_to_group("power_ups") #ver si esta bien
	
func usar(_jugador: Jugador) -> void:
	pass
