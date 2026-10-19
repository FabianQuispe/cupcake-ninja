extends Control

#Lleva al nivel facil
func _on_boton_nivel_1_pressed() -> void:
	$SonidoBoton.play()
	await $SonidoBoton.finished
	get_tree().change_scene_to_file("res://escenas/main.tscn")

#Lleva al nivel normal
func _on_boton_nivel_2_pressed() -> void:
	$SonidoBoton.play()
	await $SonidoBoton.finished
	get_tree().change_scene_to_file("res://escenas/niveles/nivel_normal.tscn")

#Lleva al nivel dificil
func _on_boton_nivel_3_pressed() -> void:
	$SonidoBoton.play()
	await $SonidoBoton.finished
	get_tree().change_scene_to_file("res://escenas/niveles/nivel_dificil.tscn")
