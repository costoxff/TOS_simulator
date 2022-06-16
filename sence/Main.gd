extends Node

var gem_tscn = load("res://sence/gem.tscn")

# Declare member variables here. Examples:
var gem_tilemap = []
var tile_size = 85
	
func get_gem(row: int, col: int):
	return gem_tilemap[row][col]


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	for col in range(5):
		var row_list = []
		for row in range(6):
			row_list.append(gem_tscn.instance())
		gem_tilemap.append(row_list)

	for row in range(5):
		for col in range(6):
			var gem = gem_tilemap[row][col]
			gem.position = gem.position.snapped(Vector2.ONE * tile_size)
			gem.position += Vector2.ONE * (tile_size/2)
			gem.position += (Vector2.RIGHT * col + Vector2.DOWN * (row)) * tile_size + $TileMap.position
			
			gem.last_info["tile_pos"] = [row, col]
			gem.last_info["type"] = gem.type
			gem.last_info["pos"] = gem.position
			
#			gem.connect("not_selected", self, "_on_Gem_not_selected")
			gem.connect("is_selected", self, "_on_Gem_is_selected")
			add_child(gem)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for row in range(5):
		for col in range(6):
			var gem = gem_tilemap[row][col]
			if gem.selected:
#				print(last_selected_gem)
				$TileMap.set_cell(col, row, gem.type)
				move_child(gem, get_child_count() - 1)
				# TODO
				# trying not to run for all the loop when reset gem on tilemap

	

# gem no_selected signal
func _on_Gem_not_selected(gem):
	gem.position = gem.last_info["pos"]
	var row = gem.last_info["tile_pos"][0]
	var col = gem.last_info["tile_pos"][1]
	$TileMap.set_cell(col, row, -1)
	print("release:", gem)
#	if gem.last_info["selected"]:
#		gem.disconnect("gem_contact", self, "_on_Gem_contact")
#		gem.last_info["selected"] = false
	gem.disconnect("gem_contact", self, "_on_Gem_contact")
	gem.disconnect("not_selected", self, "_on_Gem_not_selected")

# must select before contact
func _on_Gem_is_selected(gem):
	print("select:", gem)
	gem.last_info["selected"] = true
	gem.connect("gem_contact", self, "_on_Gem_contact")
	gem.connect("not_selected", self, "_on_Gem_not_selected")

# after selecting and contacting
func _on_Gem_contact(gem_hold, gem_contact):
	print("hold:", gem_hold, " contact:", gem_contact)
#	var pos_tmp = gem_select.last_info["pos"]
#	gem_select.last_info["pos"] = gem_contact.last_info["pos"]
#	gem_contact.last_info["pos"] = pos_tmp
#
#	var tile_pos_tmp = gem_select.last_info["tile_pos"]
#	gem_select.last_info["tile_pos"] = gem_contact.last_info["tile_pos"]
#	gem_contact.last_info["tile_pos"] = pos_tmp
	
	pass
#	if gem_contact.selected:
#		print("selected ", gem_contact)
#	else:
#		print("not selected ", gem_contact)
