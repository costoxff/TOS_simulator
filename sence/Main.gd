extends Node

var gem_tscn = load("res://sence/gem.tscn")

# Declare member variables here. Examples:
var tile_space = []
var tile_size = 85

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
#	for x in range(6):
#		for y in range(5):
#			$TileMap.set_cell(x, y, (randi() - 4) % 6)
	for col in range(5):
		var raw_list = []
		for raw in range(6):
			raw_list.append(gem_tscn.instance())
		tile_space.append(raw_list)

	for row in range(5):
		for col in range(6):
			var gem = tile_space[row][col]
			gem.position = gem.position.snapped(Vector2.ONE * tile_size)
			gem.position += Vector2.ONE * (tile_size/2)
			gem.position += (Vector2.RIGHT * col + Vector2.DOWN * (row)) * tile_size + $TileMap.position

			add_child(gem)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
