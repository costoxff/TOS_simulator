extends Node

var gem_tscn = load("res://sence/gem.tscn")

# Declare member variables here. Examples:
var tile_space = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for col in range(5):
		var raw_list = []
		for raw in range(6):
			raw_list.append(gem_tscn.instance())
		tile_space.append(raw_list)
	
	for row in range(5):
		for col in range(6):
			var gem = tile_space[row][col]
			gem.position = Vector2(50 + col * 85, 90 * row + 100)
			add_child(gem)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
