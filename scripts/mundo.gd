class_name Mundo
extends RefCounted

enum estado_mundo {activo, desactivo, completo}

var niveles: Array [Nivel] = []
var _estado: estado_mundo = estado_mundo.desactivo

func _init(estado_mundo_inicial: estado_mundo = estado_mundo.desactivo) -> void:
	_estado = estado_mundo_inicial
	
func añadir_nivel(nivel:Nivel) -> void:
	niveles.append (nivel)
	
func desactivar() -> void:
	if _estado == estado_mundo.desactivo:
		_estado == estado_mundo.activo

func completar_mundo() -> void:
	_estado= estado_mundo.completo
