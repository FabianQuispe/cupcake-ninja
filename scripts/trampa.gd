class_name Trampa
extends Node2D

#Clase base de las trampas: Lanza y shuriken

var danio: int = 1

func _ready() -> void:
	add_to_group("trampas")
	activar()

func activar() -> void:
	pass

#Muestra cuando la trampa daña
func daniar() -> bool:
	return true
