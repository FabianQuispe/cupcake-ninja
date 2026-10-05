extends Control

#El botón lleva directo a la escena de creditos. 
func _on_boton_creditos_pressed() -> void:
	$SonidoBoton.play()
	await $SonidoBoton.finished
	get_tree().change_scene_to_file("res://escenas/ui/creditos.tscn")
	
#El botón lleva a la escena Main
func _on_boton_jugar_pressed() -> void:
	$SonidoBoton.play()
	await $SonidoBoton.finished
	get_tree().change_scene_to_file("res://escenas/main.tscn")

#El botón lleva al tutorial
func _on_boton_tutorial_pressed() -> void:
	$SonidoBoton.play()
	await $SonidoBoton.finished
	get_tree().change_scene_to_file("res://escenas/ui/tutorial.tscn")
