extends Control

func _on_texture_button_1_pressed() -> void:
	$SonidoBoton.play()
	await $SonidoBoton.finished
	get_tree().change_scene_to_file("res://escenas/ui/menu.tscn")
