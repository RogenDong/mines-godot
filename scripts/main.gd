extends Main

const DIFF = [
	{
		c = 25,
		w = 8,
		h = 14,
		s = Vector2(50, 50),
	},
	{
		c = 40,
		w = 10,
		h = 18,
		s = Vector2(40, 40),
	},
	{
		c = 75,
		w = 12,
		h = 22,
		s = Vector2(33, 33),
	}
]

var cell_scen = preload("res://mine_cell.tscn")
var time := 0
var first_open := true
var w := 0
var h := 0
var cell_map = [[]]
var ended = false


func on_switch_flag(c: Cell):
	if ended: return
	if first_open:
		return on_first_open(c.x, c.y)
	self.switch_flag(c.x, c.y)
	c.switch_flag()
	c.set_style_not_open()


func on_open_cell(c: Cell):
	if ended: return
	if first_open:
		on_first_open(c.x, c.y)
	elif c.get_warn() < 1:
		on_open_around(c)
	else:
		c.on_open()
		if c.is_mine():
			end_game()


func on_open_around(c: Cell):
	if ended: return
	var around = self.get_around(c.x, c.y)
	var warn = c.get_warn()
	if warn < 1:
		return on_open_area(c.x, c.y)
	# count flagged, and find empty slot
	var count = 0
	for a in around:
		var cell: Cell = cell_map[a.y][a.x]
		if cell.is_flagged():
			count += 1
		# open area if found empty slot
		elif !cell.is_open() && cell.get_warn() < 1:
			return on_open_area(a.x, a.y)
	# count flag must >= warn
	if count < warn:
		return
	open_cells(around)


func on_open_area(x: int, y: int):
	if ended: return
	open_cells(self.get_nearby_empty_area(x, y))
	# TODO: check flag in the edge of area


func open_cells(ls):
	var _mine = false
	for p in ls:
		var cell: Cell = cell_map[p.y][p.x]
		if cell.is_flagged():
			continue
		self.open(p.x, p.y)
		cell.on_open()
		_mine = _mine || self.is_mine(p.x, p.y)
	if _mine:
		end_game()


func on_first_open(sx: int, sy: int):
	first_open = false
	self.shuffle_ignore(sx, sy)
	for y in range(0, h):
		for x in range(0, w):
			var cell: Cell = cell_map[y][x]
			var m = self.get_mark_val(x, y)
			cell.set_mark_val(m)
			if cell.is_mine():
				cell.add_to_group("mines")
	on_open_area(sx, sy)
	$StartTimer.start()


func put_cells(difficulty):
	cell_map.clear()
	var container = $Container/MineGrid
	var sz = DIFF[difficulty]
	for y in range(0, h):
		var row = []
		for x in range(0, w):
			var cell: Cell = cell_scen.instantiate()
			cell.x = x
			cell.y = y
			cell.name = "x%dy%d" % [x, y]
			cell.custom_minimum_size = sz.s
			cell.connect("e_open_cell", self.on_open_cell)
			cell.connect("e_switch_flag", self.on_switch_flag)
			cell.connect("e_open_around", self.on_open_around)
			container.add_child(cell)
			row.append(cell)
		if row.size() != sz.w:
			push_error("warn cell count: %d" % row.size())
		cell_map.append(row)
	get_tree().call_group("cells", "cust_size", difficulty)


func reset_map(difficulty):
	get_tree().call_group("cells", "queue_free")
	var d = DIFF[difficulty]
	self.w = d.w
	self.h = d.h
	$Container/MineGrid.columns = w
	self.reset_mine_map(d.c, w, h)
	put_cells(difficulty)
	time = 0
	$TimeLabel.text = "time: 0"


### HUD
func end_game():
	ended = true
	get_tree().call_group("mines", "set_style_mines")
	$NewGameBtn.show()
	$StartTimer.stop()


func _on_click_start_btn(difficulty):
	ended = false
	first_open = true
	$BtnGroup.hide()
	$Container.show()
	reset_map(difficulty)


func _on_new_game_btn_pressed():
	$Container.hide()
	$BtnGroup.show()


func _on_start_timer_timeout():
	time += 1
	$TimeLabel.text = "time: %d" % time
	if time == 999:
		$StartTimer.stop()


### base
func _ready():
	$Container.hide()
	$NewGameBtn.hide()
	$BtnGroup/EasyBtn.text = "%d x %d" % [DIFF[0].w, DIFF[0].h]
	$BtnGroup/MediBtn.text = "%d x %d" % [DIFF[1].w, DIFF[0].h]
	$BtnGroup/HardBtn.text = "%d x %d" % [DIFF[2].w, DIFF[0].h]
