class_name Nivel
extends RefCounted

enum {seguir_jugando, ganar, perder}
static var nivel_elegido: int = 1

var numero: int
var objetivo: String
var puntaje_necesario: int = 150
var tiempo_max: float = 0
var muerte_max: int = 1

func _init(numero_nivel: int = 1, objetivo_nivel: String = "") -> void:
	numero = numero_nivel
	objetivo = objetivo_nivel

#El nivel facil tendrá 90 segundos, tres vidas y el puntaje necesario para ganar es de 150.
	if numero_nivel == 1:
		puntaje_necesario= 150
		tiempo_max= 90
		muerte_max= 3
#El nivel intermedio tendrá 70 segundos, tres vidas y el puntaje necesario para ganar es de 180.
	elif numero_nivel == 2:
		puntaje_necesario = 180
		tiempo_max = 70
		muerte_max = 3
#El nivel dificil tendrá 50 segundos, una vida y el puntaje necesario para ganar es de 200.
	else:
		puntaje_necesario = 200
		tiempo_max = 50
		muerte_max = 1

	objetivo = "Consigue %d puntos en %d segundos" % [puntaje_necesario, int (tiempo_max)]

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
