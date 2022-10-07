class_name MenuAppBar
extends Node

@onready var menu_bar = $Panel
@onready var score_bar = $Panel2

@onready var file = $Panel/MarginContainer/HBoxContainer/File
@onready var action = $Panel/MarginContainer/HBoxContainer/Action
@onready var options = $Panel/MarginContainer/HBoxContainer/Options

@onready var save = $Panel/MarginContainer/HBoxContainer/File/Panel/MarginContainer/VBoxContainer/Save
@onready var restore = $Panel/MarginContainer/HBoxContainer/File/Panel/MarginContainer/VBoxContainer/Restore
@onready var restart = $Panel/MarginContainer/HBoxContainer/File/Panel/MarginContainer/VBoxContainer/Restart
@onready var quit = $Panel/MarginContainer/HBoxContainer/File/Panel/MarginContainer/VBoxContainer/Quit

@onready var see_object = $Panel/MarginContainer/HBoxContainer/Action/Panel/MarginContainer/VBoxContainer/SeeObject
@onready var inventory = $Panel/MarginContainer/HBoxContainer/Action/Panel/MarginContainer/VBoxContainer/Inventory

@onready var sound = $Panel/MarginContainer/HBoxContainer/Options/Panel/MarginContainer/VBoxContainer/Sound

var menu_index = 0
var menu_arr = [file, action, options]

var menu1_submenu = [save, restore, restart, quit]
var menu1_index = 0

var menu2_submenu = [see_object, inventory]
var menu2_index = 0

var menu3_submenu = [sound]
var menu3_index = 0

func get_class():
	return "MenuAppBar"

func is_class(value):
	if value == "MenuAppBar":
		return true
	else:
		return false

func is_showing():
	return menu_bar.visible == true

func _ready():
	menu_arr = [file, action, options]
	menu1_submenu = [save, restore, restart, quit]
	menu2_submenu = [see_object, inventory]
	menu3_submenu = [sound]
	reset()
	
func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_ESCAPE:
			if score_bar.visible:
				get_tree().paused = true
				show_menu_bar()
			else:
				get_tree().paused = false
				hide_menu_bar()
		elif menu_bar.visible and event.is_action_pressed("down"):
			select_next_sub_menu()
		elif menu_bar.visible and event.is_action_pressed("up"):
			select_prev_sub_menu()
		elif menu_bar.visible and event.is_action_pressed("right"):
			select_next_menu()
		elif menu_bar.visible and event.is_action_pressed("left"):
			select_prev_menu()
		elif event.keycode == KEY_ENTER:
			if menu_bar.visible:
				process_command()
				get_tree().paused = false
	
func reset():
	score_bar.show()
	menu_bar.hide()	
	menu_index = 0
	menu1_index = 0
	menu2_index = 0
	menu3_index = 0
	
func show_menu_bar():
	score_bar.hide()
	menu_bar.show()
	
	show_active_menu()
	show_sub_menu()
	
func hide_menu_bar():
	reset()
	
func show_active_menu():
	for item in menu_arr:
		hide_menu(item)
	
	var active_menu = menu_arr[menu_index]
	if active_menu != null:
		show_menu(active_menu)
	
func hide_menu(menu):
	var panel = menu.get_node("Panel")
	panel.hide()
	
func show_menu(menu):
	var panel = menu.get_node("Panel")
	panel.show()
	select_active_menu(menu)
	
func select_active_menu(menu):
	var label = menu
	label.set('theme_override_colors/font_color', Color(1, 1, 1, 1))

	var my_style = StyleBoxFlat.new()
	my_style.set_bg_color(Color(0,0,0,1))

	label.set('theme_override_styles/normal', my_style)
	label.grab_focus()
	
func deselect_active_menu(menu):
	var label = menu
	label.set('theme_override_colors/font_color', Color(0, 0, 0, 1))

	var my_style = StyleBoxFlat.new()
	my_style.set_bg_color(Color(1,1,1,1))

	label.set('theme_override_styles/normal', my_style)
	
func show_sub_menu():
	var submenu
	var index
	if menu_index == 0:
		submenu = menu1_submenu
		index = menu1_index
	elif menu_index == 1:
		submenu = menu2_submenu
		index = menu2_index
	elif menu_index == 2:
		submenu = menu3_submenu
		index = menu3_index
		
	for item in submenu:
		deselect_active_menu(item)
		
	var item = submenu[index]
	select_active_menu(item)
	
func select_next_sub_menu():
	var submenu
	var index
	if menu_index == 0:
		submenu = menu1_submenu
		menu1_index = menu1_index + 1
		if menu1_index >= submenu.size():
			menu1_index = 0
		index = menu1_index
	elif menu_index == 1:
		submenu = menu2_submenu
		menu2_index = menu2_index + 1
		if menu2_index >= submenu.size():
			menu2_index = 0
		index = menu2_index
	elif menu_index == 2:
		submenu = menu3_submenu
		menu3_index = menu3_index + 1
		if menu3_index >= submenu.size():
			menu3_index = 0
		index = menu3_index
		
	for item in submenu:
		deselect_active_menu(item)
		
	var item = submenu[index]
	select_active_menu(item)
	
func select_prev_sub_menu():
	var submenu
	var index
	if menu_index == 0:
		submenu = menu1_submenu
		menu1_index = menu1_index - 1
		if menu1_index < 0:
			menu1_index = submenu.size() - 1
		index = menu1_index
	elif menu_index == 1:
		submenu = menu2_submenu
		menu2_index = menu2_index - 1
		if menu2_index < 0:
			menu2_index = submenu.size() - 1
		index = menu2_index
	elif menu_index == 2:
		submenu = menu3_submenu
		menu3_index = menu3_index - 1
		if menu3_index < 0:
			menu3_index = submenu.size() - 1
		index = menu3_index
		
	for item in submenu:
		deselect_active_menu(item)
		
	var item = submenu[index]
	select_active_menu(item)
		
func select_next_menu():
	menu_index = menu_index + 1
	if menu_index >= menu_arr.size():
		menu_index = 0
	
	for item in menu_arr:
		deselect_active_menu(item)
	
	show_active_menu()
	show_sub_menu()
	
	
func select_prev_menu():
	menu_index = menu_index - 1
	if menu_index < 0:
		menu_index = menu_arr.size() - 1
	
	for item in menu_arr:
		deselect_active_menu(item)
	
	show_active_menu()
	show_sub_menu()
	
func process_command():
	if menu_index == 0:
		if menu1_index == 0:
			print('Save')
		elif menu1_index == 1:
			print('Restore')
		elif menu1_index == 2:
			print('Restart')
		elif menu1_index == 3:
			get_tree().quit()
	elif menu_index == 1:
		if menu2_index == 0:
			print('See object')
		elif menu2_index == 1:
			print('Inventory')
	elif menu_index == 2:	
		if menu3_index == 0:
			print('Sound')
