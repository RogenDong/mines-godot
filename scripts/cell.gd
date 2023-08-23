class_name Cell
extends MineCell

@export var style_w1: StyleBoxFlat
@export var style_w2: StyleBoxFlat
@export var style_w3: StyleBoxFlat
@export var style_w4: StyleBoxFlat
@export var style_w5: StyleBoxFlat
@export var style_w6: StyleBoxFlat
@export var style_w7: StyleBoxFlat
@export var style_w8: StyleBoxFlat
@export var style_mine: StyleBoxFlat
@export var style_empty: StyleBoxFlat
@export var style_unknow: StyleBoxFlat

var first_click := false

signal e_open_cell(c: Cell)
signal e_switch_flag(c: Cell)
# 打开周围未标记单位
signal e_open_around(c: Cell)


func on_open():
	self.open()
	set_style_open()
	add_to_group("opened")


func set_style_mines():
	add_theme_stylebox_override("normal", style_mine)
	if !self.is_flagged():
		self.text = "🌞"


func set_style_wrong_flag():
	if !self.is_mine():
		add_theme_stylebox_override("normal", style_w8)


func set_style_not_open():
	if self.is_flagged():
		self.text = "🚩"
	else:
		self.text = ""


func set_style_open():
	if self.is_mine():
		return set_style_mines()
	var mark = self.get_warn()
	if mark > 0:
		self.text = "%d" % mark
	add_theme_color_override("font_focus_color", Color.BLACK)
	add_theme_color_override("font_color", Color.BLACK)
	var ss: StyleBoxFlat
	match mark:
		0: ss = style_empty
		1: ss = style_w1
		2: ss = style_w2
		3: ss = style_w3
		4: ss = style_w4
		5: ss = style_w5
		6: ss = style_w6
		7: ss = style_w7
		8: ss = style_w8
		_: ss = style_mine
	add_theme_stylebox_override("normal", ss)


func on_click_1():
	print("click")
	# switch flag
	if !self.is_open():
		emit_signal("e_switch_flag", self)


func on_click_2():
	print("db click")
	# open
	var warn = self.get_warn()
	if self.is_open():
		if warn > 0:
			emit_signal("e_open_around", self)
		return
	if self.is_flagged():
		return
	emit_signal("e_open_cell", self)


func _on_pressed():
	if first_click:
		$DoubleClickTimer.stop()
		self.on_click_2()
	else:
		$DoubleClickTimer.start() # 等待第二次点击
	first_click = !first_click


func _on_db_click_timer_timeout():
	first_click = false
	$DoubleClickTimer.stop()
	self.on_click_1()


func _ready():
	add_theme_stylebox_override("normal", style_unknow)

