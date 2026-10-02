class_name Puntaje
extends RefCounted

var puntos: int = 0


func acumulacion_puntaje(cantidad: int) -> void:
	puntos += maxi(cantidad, 0)


func reiniciar() -> void:
	puntos = 0
