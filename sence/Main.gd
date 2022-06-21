extends Node

var gem_tscn = load("res://sence/gem.tscn")

# inner class
class Matric2D:
	var matric = [] setget ,get_all
	func _init(rows: int, columns: int, tscn):
		for row in range(rows):
			var row_list = []
			for col in range(columns):
				row_list.append(tscn.instance())
			matric.append(row_list)
	
	func get_all():
		return matric
		
	func swap_ele(p1: Array, p2: Array):
		# p1: point1[row, column]
		# p2: point2[row, column]
		var obj_tmp = matric[p1[0]][p1[1]]
		matric[p1[0]][p1[1]] = matric[p2[0]][p2[1]]
		matric[p2[0]][p2[1]] = obj_tmp

# variable
var gem_matric2D = null
var tile_size = 85
var is_swap = false
var gem_swaped = null
var gem_swap = null

# function
func fake_gem_display(gem, display: bool):
	var row = gem.last_info["tile_pos"][0]
	var col = gem.last_info["tile_pos"][1]
	if display:
		$TileMap.set_cell(col, row, gem.type)
	else:
		$TileMap.set_cell(col, row, -1)


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	gem_matric2D = Matric2D.new(5, 6, gem_tscn)

	for row in range(5):
		for col in range(6):
			var gem = gem_matric2D.get_all()[row][col]
			gem.position = gem.position.snapped(Vector2.ONE * tile_size)
			gem.position += Vector2.ONE * (tile_size/2)
			gem.position += (Vector2.RIGHT * col + Vector2.DOWN * (row)) * tile_size + $TileMap.position
			
			gem.last_info["tile_pos"] = [row, col]
			gem.last_info["type"] = gem.type
			gem.last_info["pos"] = gem.position
			
			gem.connect("is_selected", self, "_on_Gem_is_selected")
			add_child(gem)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_swap:
		if (gem_swaped != null) and (gem_swap != null):
			gem_swaped.position = gem_swaped.last_info["pos"]
			fake_gem_display(gem_swap, true)
		is_swap = false
	pass
				

# signal
# gem no_selected signal
func _on_Gem_not_selected(gem):
	gem.position = gem.last_info["pos"]
	fake_gem_display(gem, false)
#	print("release:", gem)
	gem.disconnect("gem_contact", self, "_on_Gem_contact")
	gem.disconnect("not_selected", self, "_on_Gem_not_selected")

# must select before contact
func _on_Gem_is_selected(gem):
	print("select:", gem)
	fake_gem_display(gem, true)
	move_child(gem, get_child_count() - 1) # move to top layer
	gem.connect("gem_contact", self, "_on_Gem_contact")
	gem.connect("not_selected", self, "_on_Gem_not_selected")

# after selecting and contacting
func _on_Gem_contact(gem_hold, gem_contact):
	print("hold:", gem_hold, " contact:", gem_contact)
	fake_gem_display(gem_hold, false)

	# swap position
	var row_h = gem_hold.last_info["tile_pos"][0]
	var col_h = gem_hold.last_info["tile_pos"][1]
	
	var row_c = gem_contact.last_info["tile_pos"][0]
	var col_c = gem_contact.last_info["tile_pos"][1]
	gem_matric2D.swap_ele([row_h, col_h], [row_c, col_c])
	
	var tile_pos_tmp = gem_hold.last_info["tile_pos"]
	gem_hold.last_info["tile_pos"] = gem_contact.last_info["tile_pos"]
	gem_contact.last_info["tile_pos"] = tile_pos_tmp
	
	var pos_tmp = gem_hold.last_info["pos"]
	gem_hold.last_info["pos"] = gem_contact.last_info["pos"]
	gem_contact.last_info["pos"] = pos_tmp
	
	gem_swaped = gem_contact
	gem_swap = gem_hold
	
	is_swap = true

	pass
