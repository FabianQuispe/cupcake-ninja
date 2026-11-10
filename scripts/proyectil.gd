class_name Proyectil
extends Node2D

var direccion := Vector2.RIGHT
var velocidad := 520.0
var danio := 1

#Hice que consulte sí los proyectiles chocan con las paredes.
func topar_proyectil_pared (delta :float) -> bool:
	var espacio := get_world_2d().direct_space_state
	var meta := global_position + direccion * (velocidad * delta + 5.0)
	var consulta := PhysicsRayQueryParameters2D.create(global_position, meta, 1)
	var respuesta := espacio.intersect_ray(consulta)
	if respuesta.is_empty(): #Sí no hay pared, entonces el proyectil continua.
		return false
		
	var elemento = respuesta["collider"]
	return not (elemento is Jugador or elemento is Enemigo)

#El proyectil avanza derecho según donde haya sido lanzado.
func avanzar(delta: float) -> void:
	position += direccion * velocidad * delta
