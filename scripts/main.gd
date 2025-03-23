extends Node2D

@onready var timer_label = $TimerLabel
@onready var break_label = $BreakLabel
@onready var start_button = $StartButton
@onready var auto_toggle_button = $AutoToggleButton
@onready var pause_button = $PauseButton
@onready var reset_button = $ResetButton
@onready var config_button = $ConfigButton
@onready var beep_sound = $AudioStreamPlayer  # Certifique-se de que o nó existe

var focus_time = 25 * 60  
var break_time = 5 * 60    
var current_time = focus_time
var is_focus = true
var auto_mode = false
var timer_running = false
var is_paused = false

func _ready():
	update_timer_label(focus_time)
	update_break_label(break_time)
	start_button.pressed.connect(start_timer)
	auto_toggle_button.pressed.connect(toggle_auto_mode)
	pause_button.pressed.connect(pause_timer)
	reset_button.pressed.connect(reset_timer)
	config_button.pressed.connect(open_config)

	var config_screen = $ConfigScreen
	if config_screen:
		config_screen.settings_changed.connect(apply_new_settings)

func _process(delta):
	if timer_running and not is_paused:
		current_time -= delta
		if is_focus:
			update_timer_label(current_time)
		else:
			update_break_label(current_time)

		if current_time <= 0:
			timer_running = false  # Para o timer antes de trocar
			if beep_sound:
				beep_sound.play()
			else:
				print("Erro: AudioStreamPlayer não encontrado!")

			switch_timer()  # Alterna entre foco e descanso quando o tempo acabar

func open_config():
	print("Abrindo ConfigScreen...")
	var config_screen = $ConfigScreen

	if config_screen:
		config_screen.visible = true
		print("ConfigScreen agora está visível!")
	else:
		print("Erro: Não foi possível encontrar ConfigScreen!")

func apply_new_settings(new_focus_time, new_break_time):
	print("Aplicando novo tempo:", new_focus_time, "segundos de foco e", new_break_time, "segundos de descanso")

	focus_time = new_focus_time
	break_time = new_break_time

	update_timer_label(focus_time)
	update_break_label(break_time)

	start_timer()

func start_timer():
	print("Iniciando o Pomodoro com tempo de:", "FOCO" if is_focus else "DESCANSO")

	current_time = focus_time if is_focus else break_time  # Define o tempo correto
	timer_running = true

	if is_focus:
		update_timer_label(current_time)
	else:
		update_break_label(current_time)

func pause_timer():
	is_paused = !is_paused
	pause_button.text = "Continuar" if is_paused else "Pausar"

func reset_timer():
	timer_running = false
	is_paused = false
	is_focus = true
	current_time = focus_time
	
	update_timer_label(focus_time)
	update_break_label(break_time)

func switch_timer():
	is_focus = !is_focus  # Alterna entre foco e descanso
	current_time = focus_time if is_focus else break_time  # Define o tempo correto

	print("Mudando para:", "FOCO" if is_focus else "DESCANSO")

	if is_focus:
		update_timer_label(current_time)
	else:
		update_break_label(current_time)

	if auto_mode:
		start_timer()  # Agora inicia automaticamente o tempo de descanso e depois volta ao foco

func toggle_auto_mode():
	auto_mode = !auto_mode
	auto_toggle_button.text = "Automático" if auto_mode else "Manual"

func update_timer_label(time_left):
	var minutes = int(time_left / 60)
	var seconds = int(time_left) % 60
	timer_label.text = "%02d:%02d" % [minutes, seconds]

func update_break_label(time_left):
	var minutes = int(time_left / 60)
	var seconds = int(time_left) % 60
	break_label.text = "%02d:%02d" % [minutes, seconds]
