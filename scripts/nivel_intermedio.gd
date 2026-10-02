class_name NivelIntermedio
extends Nivel

var tiempo: float = 90.0

func ganar_nivel(puntaje_actual: int, contrareloj: float) ->bool:
	return contrareloj <= tiempo and puntaje_actual >=150
