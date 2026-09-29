extends Control

#El botón lleva directo a la escena de creditos. 
func _on_boton_creditos_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/creditos.tscn")
	
#El botón lleva a la escena Main
func _on_boton_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/main.tscn")
