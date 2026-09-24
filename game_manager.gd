class_name GameManager
extends Node

signal juego_iniciado
signal juego_terminado

var jugador: Jugador
var puntaje := Puntaje.new()
var nivel: Nivel
var juego_activo := false


func iniciar_juego() -> void:
	juego_activo = true
	juego_iniciado.emit()


func terminar_juego() -> void:
	juego_activo = false
	juego_terminado.emit()


func reiniciar_juego() -> void:
	puntaje.reiniciar()
	juego_activo = true
	juego_iniciado.emit()