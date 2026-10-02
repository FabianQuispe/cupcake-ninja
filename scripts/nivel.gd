class_name Nivel
extends RefCounted

var numero: int
var objetivo: String
var trampas: Array[Trampa] = []


func _init(numero_nivel: int = 1, objetivo_nivel: String = "") -> void:
	numero = numero_nivel
	objetivo = objetivo_nivel


func agregar_trampa(trampa: Trampa) -> void:
	trampas.append(trampa)
