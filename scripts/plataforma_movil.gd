class_name PlataformaMovil
extends Plataforma

var posicion_iniciar: Vector2
var posicion_finalizar: Vector2
var velocidad_plataforma: float = 60.0


func _ready() -> void:
	super ._ready()
	posicion_iniciar = position

func deslizamiento(destino: Vector2, velocidad: float = 60.0) -> void:
	posicion_finalizar = destino
	velocidad_plataforma = velocidad

func actualizar(delta: float) -> void:
	var objetivo := punto_fin 
