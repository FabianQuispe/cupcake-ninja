class_name NivelDificil
extends Nivel

func ganar_nivel(puntaje_actual: int, contrareloj: float) ->bool:
	return puntaje_actual >= 300
