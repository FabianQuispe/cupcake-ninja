class_name Nivel
extends RefCounted

enum {seguir_jugando, ganar, perder}

var numero: int
var objetivo: String
var puntaje_necesario: int = 150
var tiempo_max: float = 0
var muerte_max: int = 1
var trampas: Array[Trampa] = []

func _init(numero_nivel: int = 1, objetivo_nivel: String = "") -> void:
	numero = numero_nivel
	objetivo = objetivo_nivel

#El nivel facil tendrá 300 segundos, tres vidas y el puntaje necesario para ganar es de 150.
	if numero_nivel == 1:
		puntaje_necesario= 150
		tiempo_max=300
		muerte_max= 3
#El nivel intermedio tendrá 120 segundos, tres vidas y el puntaje necesario para ganar es de 200.
	elif numero_nivel == 2:
		puntaje_necesario = 200
		tiempo_max = 120
		muerte_max = 3
#El nivel dificil tendrá 80 segundos, una vida y el puntaje necesario para ganar es de 250.
	else:
		puntaje_necesario = 250
		tiempo_max = 80
		muerte_max = 1

	objetivo = "Consigue %d puntos en %d segundos" % [puntaje_necesario, int (tiempo_max)]

func agregar_trampa(trampa: Trampa) -> void:
	trampas.append(trampa)

#Condiciones de ganar y perder.
func consultar_nivel (puntaje: int, tiempo: float, muertes: int) -> int:
	if muertes >= muerte_max:
		return perder
	elif tiempo_max > 0 and tiempo > tiempo_max:
		return perder
	elif puntaje >= puntaje_necesario:
		return ganar
	else:
		return seguir_jugando
