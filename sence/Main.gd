extends Node

var gem_tscn = load("res://sence/gem.tscn")

# Declare member variables here. Examples:
var gem_tilemap = []
var tile_size = 85
var first_move = false
	
func get_gem(row: int, col: int):
	return gem_tilemap[row][col]
	

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
#	for x in range(6):
#		for y in range(5):
#			$TileMap.set_cell(x, y, (randi() - 4) % 6)
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
			gem.last_info["last_pos"] = gem.position
			
			gem.connect("not_selected", self, "_on_Gem_not_selected")
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
				first_move = true
				# TODO
				# trying not to run for all the loop when reset gem on tilemap
				
				
func gem_position_swap(gem1, gem2):
	var pos_tmp = gem1.position
	gem1.position = gem2.position
	gem2.position = pos_tmp
	
	
func _on_Gem_not_selected(gem_release):
	print('do something')
	gem_release.position = gem_release.last_info["last_pos"]
	var row = gem_release.last_info["tile_pos"][0]
	var col = gem_release.last_info["tile_pos"][1]
	$TileMap.set_cell(col, row, -1)
	pass
