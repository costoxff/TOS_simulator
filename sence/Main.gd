extends Node

const Matrix2D = preload("res://src/Matrix2D.gd")
const gem_tscn = preload("res://sence/gem.tscn")


# variable
const tile_size: int = 85
var global_position: Array
var gem_matrix: Matrix2D = Matrix2D.new(5, 6, gem_tscn)


# function
func fake_gem_display(gem, display: bool) -> void:
	var row = gem.last_info["tile_pos"][0]
	var col = gem.last_info["tile_pos"][1]
	if display:
		$TileMap.set_cell(col, row, gem.type)
	else:
		$TileMap.set_cell(col, row, -1)
		
func swap2ele(ele1, ele2) -> Array:
	return [ele2, ele1]

func clear():
	while not gem_matrix.been_eliminated():
		var state = gem_matrix.eliminated($GemDelTimer)
		if state is GDScriptFunctionState:
			state = yield(state, "completed")
		print("eliminated state: ", state)

		# drop from upper 
		gem_matrix.move_to_up()
		state = gem_matrix.dropped(global_position, $DroppedTween)
		if state is GDScriptFunctionState:
			state = yield(state, "completed")
		print("drop state:", state)
	

# start
func _ready():
	for row in range(5):
		var col_tmp: Array = []
		for col in range(6):
			var gem = gem_matrix.get_all()[row][col]
			gem.position = gem.position.snapped(Vector2.ONE * tile_size)
			gem.position += Vector2.ONE * (tile_size/2)
			gem.position += (Vector2.RIGHT * col + Vector2.DOWN * row) * tile_size + $TileMap.position
			
			gem.last_info["tile_pos"] = [row, col]
			gem.last_info["pos"] = gem.position

			gem.connect("is_selected", self, "_on_Gem_is_selected")
			add_child(gem)
			
			col_tmp.append(gem.position)
		global_position.append(col_tmp)


func _physics_process(delta):
	pass
				
# event
func _on_Gem_not_selected(gem):
	gem.position = gem.last_info["pos"]
	fake_gem_display(gem, false)
	gem.disconnect("gem_contact", self, "_on_Gem_contact")
	gem.disconnect("not_selected", self, "_on_Gem_not_selected")
	
	clear()


## must select before contact
func _on_Gem_is_selected(gem):
	fake_gem_display(gem, true)
	move_child(gem, get_child_count() - 1) # move to top layer
	gem.connect("gem_contact", self, "_on_Gem_contact")
	gem.connect("not_selected", self, "_on_Gem_not_selected")
	

## after selecting and contacting
func _on_Gem_contact(gem_hold, gem_contact):
	fake_gem_display(gem_hold, false)
	
	# swap position
	var row_h = gem_hold.last_info["tile_pos"][0]
	var col_h = gem_hold.last_info["tile_pos"][1]

	var row_c = gem_contact.last_info["tile_pos"][0]
	var col_c = gem_contact.last_info["tile_pos"][1]
	gem_matrix.swap_ele([row_h, col_h], [row_c, col_c])

	var tmp_list = null
	tmp_list = swap2ele(gem_hold.last_info["tile_pos"],
						gem_contact.last_info["tile_pos"])
	gem_hold.last_info["tile_pos"] = tmp_list[0]
	gem_contact.last_info["tile_pos"] = tmp_list[1]

	tmp_list = swap2ele(gem_hold.last_info["pos"],
						gem_contact.last_info["pos"])
	gem_hold.last_info["pos"] = tmp_list[0]
	gem_contact.last_info["pos"] = tmp_list[1]

	
	$Tween.interpolate_property(
		gem_contact, "position", 
		gem_contact.position, gem_contact.last_info["pos"],
		.03)
	$Tween.start()
	
	fake_gem_display(gem_hold, true)
