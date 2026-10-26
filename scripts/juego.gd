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
const ESCENA_ENEMIGO_ORUGA := preload("res://escenas/enemigos/enemigo_oruga.tscn")
const ESCENA_ENEMIGO_VOLADOR := preload("res://escenas/enemigos/enemigo_volador.tscn")
const ESCENA_SHURIKEN := preload("res://escenas/trampa_shuriken.tscn")
const ESCENA_LANZA := preload("res://escenas/trampa_lanza.tscn")

func _ready() -> void:
	generador_aleatorio.randomize()
	game_manager.jugador = null
	game_manager.nivel = Nivel.new(1, "Sobrevive y consigue 100 puntos")#reemplazar por el de abajo luego 
	#game_manager.cargar_mundos(_crear_mundos())
	nivel = game_manager.nivel
	add_child(game_manager)
	game_manager.iniciar_juego()
	_crear_fondo()
	_crear_jugador()
	hud_vida = preload("res://escenas/hud_vida.tscn").instantiate()
	add_child(hud_vida)
	jugador.vidas_cambiadas.connect(_actualizar_vidas_jugador)
	_crear_enemigos()
	_crear_trampas()
	_crear_power_ups()
	


func _process(delta: float) -> void:
	if not game_manager.juego_activo:
		return
		
	tiempo_de_nivel += delta
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
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_Q and game_manager.juego_activo:
			jugador.usar_power_up(PowerUpVida.new())
		elif event.keycode == KEY_E and game_manager.juego_activo:
			jugador.usar_power_up(PowerUpEscudo.new())


func _crear_fondo() -> void:
	var escenario := ESCENA_NIVEL.instantiate()
	escenario.name = "EscenarioNivel1"
	add_child(escenario)
	move_child(escenario, 0)


func _crear_jugador() -> void:
	jugador = preload("res://escenas/jugador.tscn").instantiate()
	jugador.position = Vector2(576, 330)
	jugador.danio_disparo = 1
	game_manager.jugador = jugador
	jugador.movimiento_terminado.connect(_resolver_turno)
	jugador.ataque_realizado.connect(_resolver_ataque)
	add_child(jugador)


func _actualizar_vidas_jugador(vidas_actuales: int) -> void:
	# Actualiza el HUD y activa la derrota cuando se agotan las vidas.
	hud_vida.actualizar_vidas(vidas_actuales)
	if vidas_actuales <= 0:
		muertes_de_jugador = nivel.muerte_max


func _crear_enemigos() -> void:
	for datos in [[Vector2(440, 210), "Oruga"], [Vector2(500, 100), "Volador"], [Vector2(850, 500), "Oruga"]]:
		_crear_enemigo(datos[0], datos[1])


func _crear_enemigo(posicion: Vector2, tipo: String) -> void:
	var enemigo: Enemigo
	if tipo == "Volador":
		enemigo = ESCENA_ENEMIGO_VOLADOR.instantiate()
		enemigo.scale = Vector2(0.2, 0.2)
	else:
		enemigo = ESCENA_ENEMIGO_ORUGA.instantiate()
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
		animacion.play("lanzar_bomba" if tipo == "Volador" else "walk")


func _crear_enemigo_aleatorio() -> void:
	var posicion := Vector2.ZERO
	for intento in range(12):
		posicion = Vector2(
			generador_aleatorio.randi_range(2, 21) * 48,
			generador_aleatorio.randi_range(3, 11) * 48
		)
		if posicion.distance_to(jugador.position) >= 192.0 and not _hay_trampa_cerca(posicion):
			break
	var tipos := ["Oruga", "Volador"]
	_crear_enemigo(posicion, tipos[generador_aleatorio.randi_range(0, tipos.size() - 1)])


func _hay_trampa_cerca(posicion: Vector2) -> bool:
	for trampa in nivel.trampas:
		if is_instance_valid(trampa) and trampa.position.distance_to(posicion) < 72.0:
			return true
	return false


func _crear_trampas() -> void:
	var trampas_nivel := [[Vector2 (400, 230), ESCENA_SHURIKEN], [Vector2 (800, 300), ESCENA_LANZA]]
	for datos in trampas_nivel:
		var trampa: Trampa = datos [1].instantiate()
		trampa.position = datos[0]
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
	var direccion_normalizada := direccion_ataque.normalized()
	var perpendicular := Vector2(-direccion_normalizada.y, direccion_normalizada.x)
	for enemigo in enemigos:
		if not is_instance_valid(enemigo) or enemigo.vida <= 0:
			continue
		var vector_al_enemigo := enemigo.global_position - posicion
		var distancia_en_la_direccion := vector_al_enemigo.dot(direccion_normalizada)
		var distancia_lateral := absf(vector_al_enemigo.dot(perpendicular))
		var dentro_del_alcance := distancia_en_la_direccion >= 0.0 and distancia_en_la_direccion <= alcance
		var alineado_con_disparo := distancia_lateral <= 32.0
		# Solo reciben daño los enemigos delante del jugador y alineados con el disparo.
		if dentro_del_alcance and alineado_con_disparo:
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
	for trampa in get_tree().get_nodes_in_group("trampas"):
		if trampa.daniar() and trampa.position.distance_to(jugador.position) < 34.0:
			jugador.recibir_dano(trampa.danio)
