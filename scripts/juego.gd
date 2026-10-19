extends Node2D

var game_manager := GameManager.new()
var jugador: Jugador
var muertes_de_jugador:= 0
var enemigos: Array[Enemigo] = []
var nivel: Nivel
var hud_vida: HudVida
var estado_label: Label
var ayuda_label: Label
var objetivo_label: Label
var tiempo_de_nivel := 0.0
var generador_aleatorio := RandomNumberGenerator.new()

const ESCENA_NIVEL := preload("res://escenas/niveles/nivel_facil.tscn")
const ESCENA_ENEMIGO_PAPA := preload("res://escenas/enemigos/enemigo_papa.tscn")
const ESCENA_ENEMIGO_VOLADOR := preload("res://escenas/enemigos/enemigo_volador.tscn")


func _ready() -> void:
	generador_aleatorio.randomize()
	game_manager.jugador = null
	game_manager.nivel = Nivel.new(1, "Sobrevive y consigue 100 puntos")#reemplazar por el de abajo luego 
	#game_manager.cargar_mundos(_crear_mundos())
	nivel = game_manager.nivel
	add_child(game_manager)
	game_manager.iniciar_juego()
	_crear_fondo()
	_crear_hud()
	_crear_paredes()
	_crear_jugador()
	hud_vida = preload("res://escenas/hud_vida.tscn").instantiate()
	add_child(hud_vida)
	jugador.vida_cambiada.connect(hud_vida.actualizar_vidas)
	_crear_enemigos()
	_crear_trampas()
	_crear_power_ups()
	
	_actualizar_hud()


func _process(delta: float) -> void:
	if not game_manager.juego_activo:
		return
		
	tiempo_de_nivel += delta
	_actualizar_hud()
	_revisar_contactos()
	
	var resultado = nivel.consultar_nivel(game_manager.puntaje.puntos, tiempo_de_nivel, muertes_de_jugador)
	
	if resultado == Nivel.ganar:
		game_manager.terminar_juego()
		estado_label.text = "GANASTE - pulsa R para reiniciar"
	elif resultado == Nivel.perder:
		game_manager.terminar_juego()
		estado_label.text = "DERROTA - pulsa R para reiniciar"
		
	if jugador.position.y > 700.0:
		jugador.position = Vector2(576.0, 330.0)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		game_manager.terminar_juego()
		estado_label.text = "PAUSA - pulsa R para reiniciar"
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_R and not game_manager.juego_activo:
			get_tree().reload_current_scene()
		elif event.keycode == KEY_Q and game_manager.juego_activo:
			jugador.usar_power_up(PowerUpVida.new())
		elif event.keycode == KEY_E and game_manager.juego_activo:
			jugador.usar_power_up(PowerUpEscudo.new())


func _crear_fondo() -> void:
	var escenario := ESCENA_NIVEL.instantiate()
	escenario.name = "EscenarioNivel1"
	add_child(escenario)
	move_child(escenario, 0)


func _crear_hud() -> void:
	estado_label = Label.new()
	estado_label.position = Vector2(32, 24)
	estado_label.add_theme_font_size_override("font_size", 26)
	add_child(estado_label)

	objetivo_label = Label.new()
	objetivo_label.position = Vector2(32, 68)
	objetivo_label.add_theme_color_override("font_color", Color("a9bad8"))
	add_child(objetivo_label)

	ayuda_label = Label.new()
	ayuda_label.position = Vector2(770, 24)
	ayuda_label.text = "Flechas o swipe: deslizar   A: atacar   Q/E: power-up"
	ayuda_label.add_theme_color_override("font_color", Color("a9bad8"))
	add_child(ayuda_label)


func _crear_jugador() -> void:
	jugador = preload("res://escenas/jugador.tscn").instantiate()
	jugador.position = Vector2(576, 330)
	jugador.danio_disparo = 1
	game_manager.jugador = jugador
	jugador.movimiento_terminado.connect(_resolver_turno)
	jugador.ataque_realizado.connect(_resolver_ataque)
	add_child(jugador)


func _crear_paredes() -> void:
	var limites := [
		[Vector2(576, 104), Vector2(1088, 16)],
		[Vector2(576, 616), Vector2(1088, 16)],
		[Vector2(32, 360), Vector2(16, 512)],
		[Vector2(1120, 360), Vector2(16, 512)]
	]
	for limite in limites:
		var pared := StaticBody2D.new()
		pared.collision_layer = 1
		pared.position = limite[0]
		var forma := CollisionShape2D.new()
		var rectangulo := RectangleShape2D.new()
		rectangulo.size = limite[1]
		forma.shape = rectangulo
		pared.add_child(forma)
		add_child(pared)


func _crear_enemigos() -> void:
	for datos in [[Vector2(240, 210), "Papa"], [Vector2(900, 230), "Volador"], [Vector2(850, 500), "Papa"]]:
		_crear_enemigo(datos[0], datos[1])


func _crear_enemigo(posicion: Vector2, tipo: String) -> void:
	var enemigo: Enemigo
	if tipo == "Volador":
		enemigo = ESCENA_ENEMIGO_VOLADOR.instantiate()
		enemigo.scale = Vector2(0.2, 0.2)
	else:
		enemigo = ESCENA_ENEMIGO_PAPA.instantiate()
		enemigo.scale = Vector2(0.3, 0.3)

	var sprite := enemigo.get_node_or_null("Sprite2D") as Sprite2D
	if sprite:
		sprite.position = Vector2.ZERO
	var forma_colision := enemigo.get_node_or_null("CollisionShape2D") as CollisionShape2D
	if forma_colision:
		forma_colision.position = Vector2.ZERO

	enemigo.position = posicion
	enemigo.tipo = tipo
	enemigo.objetivo = jugador
	enemigo.danio_contacto = 1
	enemigos.append(enemigo)
	add_child(enemigo)
	var animacion := enemigo.get_node_or_null("AnimationPlayer") as AnimationPlayer
	if animacion:
		animacion.play("fly" if tipo == "Volador" else "walk")


func _crear_enemigo_aleatorio() -> void:
	var posicion := Vector2.ZERO
	for intento in range(12):
		posicion = Vector2(
			generador_aleatorio.randi_range(2, 21) * 48,
			generador_aleatorio.randi_range(3, 11) * 48
		)
		if posicion.distance_to(jugador.position) >= 192.0 and not _hay_trampa_cerca(posicion):
			break
	var tipos := ["Papa", "Volador"]
	_crear_enemigo(posicion, tipos[generador_aleatorio.randi_range(0, tipos.size() - 1)])


func _hay_trampa_cerca(posicion: Vector2) -> bool:
	for trampa in nivel.trampas:
		if is_instance_valid(trampa) and trampa.position.distance_to(posicion) < 72.0:
			return true
	return false


func _crear_trampas() -> void:
	for posicion in [Vector2(430, 235), Vector2(700, 470), Vector2(1000, 360)]:
		var trampa := Trampa.new()
		trampa.position = posicion
		trampa.danio = 1
		nivel.agregar_trampa(trampa)
		add_child(trampa)


func _crear_power_ups() -> void:
	var vida := PowerUpVida.new()
	vida.cantidad_vidas = 3
	jugador.power_up_disponible = vida


func _resolver_turno(_direccion_movimiento: Vector2) -> void:
	_revisar_contactos()


func _resolver_ataque(posicion: Vector2, direccion_ataque: Vector2, alcance: float, danio: int) -> void:
	for enemigo in enemigos:
		if not is_instance_valid(enemigo) or enemigo.vida <= 0:
			continue
		var vector_al_enemigo := enemigo.global_position - posicion
		var distancia := vector_al_enemigo.length()
		if distancia <= alcance and direccion_ataque.dot(vector_al_enemigo.normalized()) > 0.75:
			enemigo.recibir_dano(danio)
			if enemigo.vida <= 0:
				game_manager.puntaje.acumulacion_puntaje(10)
				enemigo.queue_free()
				_crear_enemigo_aleatorio.call_deferred()
	_revisar_contactos()


func _revisar_contactos() -> void:
	for enemigo in enemigos:
		if is_instance_valid(enemigo) and enemigo.vida > 0 and enemigo.global_position.distance_to(jugador.global_position) < 34.0:
			jugador.recibir_dano(enemigo.danio_contacto)
	for trampa in nivel.trampas:
		if is_instance_valid(trampa) and trampa.position.distance_to(jugador.position) < 34.0:
			jugador.recibir_dano(trampa.danio)


func _actualizar_hud() -> void:
	if not is_instance_valid(jugador):
		return
	estado_label.text = "VIDA: %d    PUNTOS: %d" % [jugador.vida, game_manager.puntaje.puntos]
	objetivo_label.text = "%s    Tiempo: %02d s" % [nivel.objetivo, int(tiempo_de_nivel)]
