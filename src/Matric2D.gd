extends Node


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
