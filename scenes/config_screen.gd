extends Control

signal settings_changed(new_focus_time, new_break_time)  # Emite os tempos novos

@onready var focus_time_input = $VBoxContainer/FocusTimeInput
@onready var break_time_input = $VBoxContainer/BreakTimeInput
@onready var save_button = $VBoxContainer/SaveButton
@onready var cancel_button = $VBoxContainer/CancelButton

func _ready():
	save_button.pressed.connect(_on_save_pressed)
	cancel_button.pressed.connect(_on_cancel_pressed)

func _on_save_pressed():
	var focus_time = int(focus_time_input.value) * 60  # Converte minutos para segundos
	var break_time = int(break_time_input.value) * 60

	settings_changed.emit(focus_time, break_time)  # Emite os tempos para o Main
	visible = false  # Esconde a tela
	print("Novo tempo definido:", focus_time, "segundos")  # Debug

func _on_cancel_pressed():
	visible = false  # Apenas fecha a tela de configuração
