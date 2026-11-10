extends Control

#Lleva al nivel facil
func _on_boton_nivel_1_pressed() -> void:
	_jugar_nivel(1)

#Lleva al nivel normal
func _on_boton_nivel_2_pressed() -> void:
	_jugar_nivel(2)

#Lleva al nivel dificil
func _on_boton_nivel_3_pressed() -> void:
	_jugar_nivel(3)

#Segun el nivel elegido, aparecerán sus condiciones para ganar y te llevará al nivel.
func _jugar_nivel(numero_nivel: int) -> void:
	Nivel.nivel_elegido = numero_nivel
	$SonidoBoton.play()
	await $SonidoBoton.finished
	get_tree().change_scene_to_file("res://escenas/main.tscn")

#Lleva al menu
func _on_boton_volver_pressed() -> void:
	$SonidoBoton.play()
	await $SonidoBoton.finished
	get_tree().change_scene_to_file("res://escenas/ui/menu.tscn")
