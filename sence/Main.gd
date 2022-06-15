extends Node

var gem_tscn = load("res://sence/gem.tscn")

# Declare member variables here. Examples:
var gem_tilemap = []
var tile_size = 85
var last_selected_gem = {
					"position": [0, 0], 
					"selected": false,
					"type": 0,
					"current_pos": Vector2(0, 0)}
	
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

			add_child(gem)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for row in range(5):
		for col in range(6):
			var gem = gem_tilemap[row][col]
			if gem.selected:
				last_selected_gem = {
					"position": [row, col], 
					"selected": gem.selected,
					"type": gem.type,
					"current_pos": gem.current_position}
#				print(last_selected_gem)
				$TileMap.set_cell(col, row, gem.type)
			else:
				# TODO
				# trying not to run for all the loop when reset gem
				$TileMap.set_cell(col, row, -1)		
	pass
