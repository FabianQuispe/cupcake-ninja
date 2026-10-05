class_name Nivel
extends RefCounted
enum resultado_nivel {ganar, perder}

var numero: int
var objetivo: String
var puntaje_necesario: int = 150
var tiempo_max: float = 0
var muerte_max: int = 1
var trampas: Array[Trampa] = []


func _init(numero_nivel: int = 1, objetivo_nivel: String = "") -> void:
	numero = numero_nivel
	objetivo = objetivo_nivel


func agregar_trampa(trampa: Trampa) -> void:
	trampas.append(trampa)

#Condiciones de nivel
func consultar_nivel (puntaje: int, tiempo: float, muertes: int) -> resultado_nivel:
	if muertes > muerte_max:
		return resultado_nivel.perder
	elif tiempo_max > 0 and tiempo > tiempo_max:
		return resultado_nivel.perder
	elif puntaje < puntaje_necesario:
		return resultado_nivel.perder
	else:
		return resultado_nivel.ganar
