class_name Jugador
extends Personaje

const ESCENA_DISPARO := preload("res://escenas/proyectil_jugador.tscn")

signal movimiento_terminado(direccion: Vector2)
signal ataque_realizado(posicion: Vector2, direccion: Vector2, alcance: float, danio: int)
signal vidas_cambiadas (vidas_actuales: int)

enum Estado { IDLE, SLIDING }
@export var tamano_casilla := 48.0
@export var velocidad_deslizamiento := 240.0
@export var alcance_ataque := 96.0
@onready var sprite: Sprite2D = $RobotJugador
@onready var animacion: AnimationPlayer = $AnimationPlayer

# Duración de la invulnerabilidad y del recorrido visual del disparo.
const TIEMPO_INVULNERABLE := 1.0
const DURACION_DISPARO := 0.10

var estado := Estado.IDLE
var direccion := Vector2.RIGHT
var power_up_disponible: PowerUp
var vidas_restantes: int = 3
var escudo_activo := false
var turnos_escudo := 0
var raycast_ataque: RayCast2D
var _toque_inicial := Vector2.ZERO
var _hay_toque := false
var _tiempo_invulnerable := 0.0
var _esta_recibiendo_dano := false

func _ready() -> void:
	nombre = "Jugador"
	vida = 3
	collision_mask = 1
	sprite.scale = Vector2(0.1, 0.1)
	
	raycast_ataque = RayCast2D.new()
	raycast_ataque.name = "RayCastAtaque"
	raycast_ataque.enabled = true
	raycast_ataque.collision_mask = 1
	add_child(raycast_ataque)
	queue_redraw()


func _physics_process(delta: float) -> void:
	if estado == Estado.SLIDING:
		_deslizar_hasta_colision(delta)
	_tiempo_invulnerable = maxf(_tiempo_invulnerable - delta, 0.0)

func _input(event: InputEvent) -> void:
	# Evita acciones mientras el jugador parpadea o ya perdió todas sus vidas.
	if _esta_recibiendo_dano or vidas_restantes <= 0:
		return
	if event is InputEventKey and event.pressed and not event.echo:
		var direccion_tecla := _direccion_de_tecla(event.keycode)
		if direccion_tecla != Vector2.ZERO:
			iniciar_deslizamiento(direccion_tecla)
		elif event.keycode == KEY_A:
			realizar_ataque()
	elif event is InputEventScreenTouch:
		if event.pressed:
			_toque_inicial = event.position
			_hay_toque = true
		elif _hay_toque:
			_hay_toque = false
			var desplazamiento: Vector2 = event.position - _toque_inicial
			if desplazamiento.length() >= tamano_casilla * 0.35:
				iniciar_deslizamiento(_direccion_de_deslizamiento(desplazamiento))


func _direccion_de_tecla(tecla: Key) -> Vector2:
	match tecla:
		KEY_LEFT:
			return Vector2.LEFT
		KEY_RIGHT:
			return Vector2.RIGHT
		KEY_UP:
			return Vector2.UP
		KEY_DOWN:
			return Vector2.DOWN
	return Vector2.ZERO


func _direccion_de_deslizamiento(desplazamiento: Vector2) -> Vector2:
	if absf(desplazamiento.x) > absf(desplazamiento.y):
		return Vector2.RIGHT if desplazamiento.x > 0.0 else Vector2.LEFT
	return Vector2.DOWN if desplazamiento.y > 0.0 else Vector2.UP


func iniciar_deslizamiento(nueva_direccion: Vector2) -> void:
	if nueva_direccion == Vector2.ZERO or _esta_recibiendo_dano or vidas_restantes <= 0:
		return
	direccion = nueva_direccion
	_actualizar_orientacion()
	if estado == Estado.IDLE:
		estado = Estado.SLIDING
		animacion.play("fly_jugador")

func _actualizar_orientacion() -> void:
	if direccion.x<0:
		sprite.flip_h = true
	elif direccion.x>0:
		sprite.flip_h = false
	elif direccion.y<0:
		sprite.flip_v = true
	elif direccion.y > 0:
		sprite.flip_v = false


func _deslizar_hasta_colision(delta: float) -> void:
	var distancia := velocidad_deslizamiento * delta
	var colision := move_and_collide(direccion * distancia)
	if colision != null:
		finalizar_deslizamiento(false)


func finalizar_deslizamiento(ajustar_a_casilla: bool = true) -> void:
	estado = Estado.IDLE
	velocity = Vector2.ZERO
	if ajustar_a_casilla:
		global_position = _ajustar_a_casilla(global_position)
	movimiento_terminado.emit(direccion)
	_consumir_turno()
	animacion.stop()
	sprite.frame = 3
	

func _ajustar_a_casilla(posicion: Vector2) -> Vector2:
	return Vector2(round(posicion.x / tamano_casilla) * tamano_casilla, round(posicion.y / tamano_casilla) * tamano_casilla)


func realizar_ataque() -> void:
	if _esta_recibiendo_dano or vidas_restantes <= 0:
		return
	sprite.frame = 2
	raycast_ataque.target_position = direccion * alcance_ataque
	raycast_ataque.force_raycast_update()
	var alcance_real := alcance_ataque
	# Un enemigo no debe cortar el alcance: el disparo puede alcanzarlo.
	if raycast_ataque.is_colliding() and not (raycast_ataque.get_collider() is Enemigo):
		var punto_bloqueo := raycast_ataque.get_collision_point()
		alcance_real = global_position.distance_to(punto_bloqueo) - 18.0
	alcance_real = maxf(alcance_real, 0.0)
	_disparar_visual(alcance_real)
	ataque_realizado.emit(global_position, direccion, alcance_real, maxi(danio_disparo, 35))
	_consumir_turno()
	await get_tree().create_timer(0.3).timeout
	sprite.frame = 2


func _disparar_visual(alcance: float) -> void:
	# Anima el sprite del disparo desde el jugador hasta el límite de alcance.
	var disparo: Node2D = ESCENA_DISPARO.instantiate()
	get_tree().current_scene.add_child(disparo)
	var posicion_inicial := global_position + direccion * 20.0
	disparo.global_position = posicion_inicial
	disparo.global_rotation = direccion.angle()
	var animacion_disparo := disparo.get_node("AnimationPlayer") as AnimationPlayer
	animacion_disparo.play("disparar_jugador")
	var desplazamiento := disparo.create_tween()
	desplazamiento.tween_property(
		disparo,
		"global_position",
		global_position + direccion * maxf(alcance, 20.0),
		DURACION_DISPARO
	)
	get_tree().create_timer(0.55).timeout.connect(disparo.queue_free)


func _consumir_turno() -> void:
	if not escudo_activo:
		return
	turnos_escudo -= 1
	if turnos_escudo <= 0:
		escudo_activo = false
		queue_redraw()


func recibir_dano(cantidad: int) -> void:
	if escudo_activo or _tiempo_invulnerable > 0.0:
		return
	# Interrumpe el movimiento y da un breve período de invulnerabilidad.
	_tiempo_invulnerable = TIEMPO_INVULNERABLE
	_esta_recibiendo_dano = true
	estado = Estado.IDLE
	velocity = Vector2.ZERO
	animacion.stop()
	sprite.frame = 3
	super.recibir_dano(cantidad)
	if vida <= 0:
		vidas_restantes -= 1
		vidas_cambiadas.emit(vidas_restantes)
		if vidas_restantes > 0:
			vida = 3
			vida_cambiada.emit(vida)
	_parpadear_por_dano()


func _parpadear_por_dano() -> void:
	# Bloquea el control hasta que termina el parpadeo rojo.
	var parpadeo := create_tween()
	for _iteracion in range(3):
		parpadeo.tween_property(sprite, "modulate", Color(1.0, 0.15, 0.15), 0.1)
		parpadeo.tween_property(sprite, "modulate", Color.WHITE, 0.1)
	await parpadeo.finished
	_esta_recibiendo_dano = false

func usar_power_up(power_up: PowerUp) -> void:
	if power_up_disponible != null:
		power_up_disponible.usar(self)
		power_up_disponible = null
	else:
		power_up.usar(self)


func activar_escudo(duracion: float) -> void:
	escudo_activo = true
	turnos_escudo = maxi(ceili(duracion), 1)
	queue_redraw()


func _draw() -> void:
	var color := Color("5ee1a7") if not escudo_activo else Color("6bc7ff")
	draw_circle(Vector2.ZERO, 19.0, color)
	draw_circle(Vector2.ZERO, 9.0, Color("182338"))
	if escudo_activo:
		draw_arc(Vector2.ZERO, 28.0, 0.0, TAU, 32, Color("b4ecff"), 3.0)
