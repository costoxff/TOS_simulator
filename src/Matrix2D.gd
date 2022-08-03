# custom for gem.tscn
extends Node

class_name Matrix2D

var matrix: Array = [] setget ,get_all
var glo_cols: int # global columns variable
var glo_rows: int # global rows variable

func _init(rows: int, columns: int, tscn):
	glo_cols = columns
	glo_rows = rows
	for row in range(rows):
		var row_list = []
		for col in range(columns):
			row_list.append(tscn.instance())
		matrix.append(row_list)

#func _ready():
	

func get_all() -> Array:
	return matrix
			
func swap_ele(p1: Array, p2: Array):
	# p1: point1[row, column]
	# p2: point2[row, column]
	var obj_tmp = matrix[p1[0]][p1[1]]
	matrix[p1[0]][p1[1]] = matrix[p2[0]][p2[1]]
	matrix[p2[0]][p2[1]] = obj_tmp

func labeling() -> Array:
	var h_label_matrix = [] # horizontal labeling
	for row in range(glo_rows):
		h_label_matrix.append([-1, -1, -1, -1, -1, -1])
		
	for row in range(glo_rows):
		for col in range(glo_cols - 2):
			var first = matrix[row][col].type
			var second = matrix[row][col + 1].type
			var third = matrix[row][col + 2].type
			
			if first == second and second == third:
				h_label_matrix[row][col] = first
				h_label_matrix[row][col + 1] = second
				h_label_matrix[row][col + 2] = third

	var v_label_matrix = [] # vertical labeling
	for row in range(glo_rows):
		v_label_matrix.append([-1, -1, -1, -1, -1, -1])
	
	for col in range(glo_cols):
		for row in range(glo_rows - 2):
			var first = matrix[row][col].type
			var second = matrix[row + 1][col].type
			var third = matrix[row + 2][col].type
			
			if first == second and second == third:
				v_label_matrix[row][col] = first
				v_label_matrix[row + 1][col] = first
				v_label_matrix[row + 2][col] = first
	
	var union_label_matrix = [] # union labeling
	for i in range(glo_rows):
		union_label_matrix.append([-1, -1, -1, -1, -1, -1])
	for row in range(glo_rows):
		for col in range(glo_cols):
			if h_label_matrix[row][col] != -1:
				union_label_matrix[row][col] = h_label_matrix[row][col]
			if v_label_matrix[row][col] != -1:
				union_label_matrix[row][col] = v_label_matrix[row][col]
	
	return union_label_matrix

func all(array2d: Array):
	var h = array2d.size()
	var w = array2d[0].size()
	for i in range(h):
		for j in range(w):
			if array2d[i][j] == false:
				return false
	return true

func bfs_groups() -> Array:
	var labeling_matrix = labeling()
	var h = labeling_matrix.size()
	var w = labeling_matrix[0].size()
	
	var visited = []
	for i in range(h):
		var tmp = []
		for j in range(w):
			tmp.append(false)
		visited.append(tmp)
	
	var queue = []
	var type = null
	var can_del_stack: Array
	
	while not all(visited):
		var break_flag = false
		for i in range(h):
			for j in range(w):
				if labeling_matrix[i][j] == -1:
					visited[i][j] = true
				if not visited[i][j]:
					type = labeling_matrix[i][j]
					queue.append([i, j])
					break_flag = true
					break
			if break_flag:
				break
		
		# grouping
		var can_del_group = []
		while not queue.empty():
			var pos = queue.pop_front()
			var row = pos[0]
			var col = pos[1]
			
			if row < 0 or col < 0 or row >= h or col >= w \
			or visited[row][col] or labeling_matrix[row][col] != type:
				continue
			
			visited[row][col] = true
			can_del_group.append([row, col])
			
			queue.append([row, col - 1])  # go left
			queue.append([row, col + 1])  # go right
			queue.append([row - 1, col])  # go up
			queue.append([row + 1, col])  # go down
		can_del_stack.append(can_del_group)
		
	if can_del_stack.empty():
		return []
	return can_del_stack

# if eliminated done retrun true
func eliminated(timer: Timer):
	var gem_groups = bfs_groups()
	var gem: Gem
	if gem_groups.empty():
		return
		
	for group in gem_groups:
		for pos in group:
			gem = matrix[pos[0]][pos[1]]
			gem.set_visible(false)
		timer.start()
		yield(timer, "timeout")
	
func move_to_up():
	var gem: Gem
	for row in glo_rows:
		for col in glo_cols:
			gem = matrix[row][col]
			if not gem.is_visible():
				var new_pos = gem.get_position() * Vector2(1, -1)
				gem.set_position(new_pos)
				gem.last_info["pos"] = new_pos
				
						
func dropped(position_table: Array, tween: Tween):
	var gem: Gem
	var drop_table: Array
	
	for row in range(glo_rows):
		var col_tmp: Array
		for col in range(glo_cols):
			gem = matrix[row][col]
			if gem.is_visible():
				col_tmp.append(true)
			else:
				col_tmp.append(false)
		drop_table.append(col_tmp)
	
	for i in drop_table:
		print(i)
	
	var drop_groups: Array
	for col in range(glo_cols):
		var drop_tmp: Array
		for row in range(glo_rows):
			gem = matrix[row][col]
			if gem.is_visible():
				drop_tmp.append(gem)
			else:
				var tmp = [gem]
				tmp.append_array(drop_tmp)
				drop_tmp = tmp
		drop_groups.append(drop_tmp)
		
		
	for row in range(glo_rows):
		for col in range(glo_cols):
			gem = drop_groups[col][row]
			matrix[row][col] = gem
			gem.last_info["tile_pos"] = [row, col]
			if not gem.is_visible():
				gem.set_visible(true)
				gem.random_type()
			gem.last_info["type"] = gem.type
			gem.last_info["pos"] = position_table[row][col]
			tween.interpolate_property(gem, "position", 
										gem.get_position(),
										position_table[row][col],
										0.2)
			tween.start()
			
			
		
#	for col in range(glo_cols):
#		var col_tmp: Array
#		for row in range(glo_rows-1, -1, -1):
#			gem = matrix[row][col]
#			if gem.is_visible():
#				col_tmp.append(true)
#		for i in range(5 - col_tmp.size()):
#			col_tmp.append(false)
#		col_tmp.invert()
#		for j in range(glo_rows):
#			drop_table[j][col] = col_tmp[j]
	
	
