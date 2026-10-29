class_name Proyectil
extends Node2D

var direccion := Vector2.RIGHT
var velocidad := 520.0
var danio := 1

func topar_proyectil_pared (delta :float) -> bool:
	var espacio := get_world_2d().direct_space_state
	var meta := global_position + direccion * (velocidad * delta + 5.0)
	var con := PhysicsRayQueryParameters2D.create(global_position, meta, 1)
	var res := espacio.intersect_ray(con)
	if res.is_empty():
		return false
		
	var elemento = res["collider"]
	return not (elemento is Jugador or elemento is Enemigo)

func avanzar(delta: float) -> void:
	position += direccion * velocidad * delta
