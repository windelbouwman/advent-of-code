
from vectype import Vector, new_vector
from listtype import List
from optiontype import option_unwrap
from std import print, read_file, get_arg
from strlib import trim, split_lines, str_to_int, split_string
from math import abs, min
from utils import unimplemented
from sorting import sort_list
from shapelib import Polygon, Path, Point, str_point

type Points = Vector[Point]

pub fn main() -> int:
	let points = read_points(filename: get_arg(arg: 0))
	part1(points)
	part2(points)
	0

fn read_points(filename: str) -> Points:
	let text = read_file(filename)
	let points: Vector[Point] = new_vector()
	for line in split_lines(text):
		let parts = split_string(text: trim(text: line), sep: ',')
		points.append(Point(x: str_to_int(parts[0]), y: str_to_int(parts[1])))
	points

fn part1(points: Points):
	var max_area = 0
	var i = 0
	while i < points.len():
		let a = points[i]
		var j = i + 1
		while j < points.len():
			let b = points[j]
			let area = calc_area(a, b)
			if area > max_area:
				max_area = area
			j += 1
		i += 1
	print("Part 1: {max_area}")

fn part2(points: Points):
	var max_area = 0
	let polygon = scale_polygon(polygon: make_polygon(points), factor: 2)
	var i = 0
	while i < points.len():
		let a = points[i]
		var j = i + 1
		while j < points.len():
			let b = points[j]
			let rectangle = make_rectangle(a, b)
			let area = calc_area(a, b)
			if area > max_area:
				let rect = shrink_rect(rect: scale_rect(rect: rectangle, factor: 2), amount: 1)
				# print("Considering area {area} in {str_point(a)} and {str_point(b)}")
				if is_rect_contained_in_polygon(rect, polygon):
					max_area = area
			j += 1
		i += 1
	print("Part 2: {max_area}")

fn calc_area(a: Point, b: Point) -> int:
	let dx = abs(a.x - b.x) + 1
	let dy = abs(a.y - b.y) + 1
	dx * dy

fn vector_to_list[T](v?: Vector[T]) -> List[T]:
	let ls: List[T] = List()
	for x in v:
		ls.append(x)
	ls

fn make_polygon(points: Vector[Point]) -> Polygon:
	Polygon(path: Path(points: vector_to_list(points)))

fn make_rectangle(a: Point, b: Point) -> Rectangle:
	let x = min(a: a.x, b: b.x)
	let y = min(a: a.y, b: b.y)
	let width = abs(a.x - b.x)
	let height = abs(a.y - b.y)
	Rectangle(x, y, width, height)

struct Rectangle:
	x: int
	y: int
	width: int
	height: int

fn is_rect_contained_in_polygon(rect: Rectangle, polygon: Polygon) -> bool:
	# let crossings2 = get_crossings_along_infinite_vline(polygon, x: rect.x + rect.width)
	if is_point_contained_in_polygon(point: Point(x: rect.x, y: rect.y), polygon):
		if hline_crosses(x1: rect.x, x2: rect.x + rect.width, y: rect.y, polygon):
			false
		elif hline_crosses(x1: rect.x, x2: rect.x + rect.width, y: rect.y + rect.height, polygon):
			false
		elif vline_crosses(y1: rect.y, y2: rect.y + rect.height, x: rect.x, polygon):
			false
		elif vline_crosses(y1: rect.y, y2: rect.y + rect.height, x: rect.x + rect.width, polygon):
			false
		else:
			true
	else:
		false

fn cmp_int(a: int, b: int) -> bool:
	a < b

fn hline_crosses(x1: int, x2: int, y: int, polygon: Polygon) -> bool:
	let crossings = get_crossings_along_infinite_hline(polygon, y)
	for crossing in sort_list(crossings, cmp: cmp_int):
		let c: int = crossing
		if c > x1 and c < x2:
			return true
	false

fn vline_crosses(y1: int, y2: int, x: int, polygon: Polygon) -> bool:
	let crossings = get_crossings_along_infinite_vline(polygon, x)
	for crossing in sort_list(crossings, cmp: cmp_int):
		let c: int = crossing
		if c > y1 and c < y2:
			return true
	false

fn is_point_contained_in_polygon(point: Point, polygon: Polygon) -> bool:
	# Ray trace along left side of rectangle
	let bounds = get_bounding_box(polygon)
	# print("bounding box: {rect_to_string(rect: bounds)}, point: {str_point(point)}")
	let y = bounds.y - 1
	let crossings = get_crossings_along_infinite_vline(polygon, x: point.x)
	# Count crossings to corner:
	var in_polygon = false
	for crossing in sort_list(crossings, cmp: cmp_int):
		let c: int = crossing
		if c > point.y:
			return in_polygon
		else:
			in_polygon = not in_polygon
	false

struct Line:
	a: Point
	b: Point

fn get_crossings_along_infinite_vline(polygon: Polygon, x: int) -> List[int]:
	let crossings: List[int] = List()
	for pair in polygon_to_lines(polygon):
		if pair.a.x < x and pair.b.x > x:
			let dy_dx = (pair.b.y - pair.a.y) / (pair.b.x - pair.a.x)
			let y = pair.a.y + dy_dx * (x - pair.a.x)
			crossings.append(y)
		elif pair.b.x < x and pair.a.x > x:
			let dy_dx = (pair.a.y - pair.b.y) / (pair.a.x - pair.b.x)
			let y = pair.b.y + dy_dx * (x - pair.b.x)
			crossings.append(y)
	crossings

fn get_crossings_along_infinite_hline(polygon: Polygon, y: int) -> List[int]:
	let crossings: List[int] = List()
	for pair in polygon_to_lines(polygon):
		if pair.a.y < y and pair.b.y > y:
			let dx_dy = (pair.b.x - pair.a.x) / (pair.b.y - pair.a.y)
			let x = pair.a.x + dx_dy * (y - pair.a.y)
			crossings.append(x)
		elif pair.b.y < y and pair.a.y > y:
			let dx_dy = (pair.a.x - pair.b.x) / (pair.a.y - pair.b.y)
			let x = pair.b.x + dx_dy * (y - pair.b.y)
			crossings.append(x)
	crossings

fn do_lines_cross(line: Line, line2: Line) -> bool:
	""" Test if 2 lines cross """
	unimplemented("line crossing")

fn polygon_to_lines(polygon: Polygon) -> List[Line]:
	let pairs: List[Line] = List()
	let i = polygon.path.points.iter()
	var a = option_unwrap(i.next())
	loop:
		case i.next():
			Some(b):
				pairs.append(Line(a, b))
				a = b
			None:
				break
	pairs.append(Line(a, b: polygon.path.points.first()))
	pairs

fn get_bounding_box(polygon: Polygon) -> Rectangle:
	""" Get the bounding box of a polygon """
	let p1 = polygon.path.points[0]
	var min_x = p1.x
	var max_x = p1.x
	var min_y = p1.y
	var max_y = p1.y
	for p in polygon.path.points:
		if p.x < min_x:
			min_x = p.x
		if p.x > max_x:
			max_x = p.x
		if p.y < min_y:
			min_y = p.y
		if p.y > max_y:
			max_y = p.y
	let width = max_x - min_x
	let height = max_y - min_y
	Rectangle(x: min_x, y: min_y, width, height)

fn rect_to_string(rect: Rectangle) -> str:
	"Rect({rect.x},{rect.y},width={rect.width},height={rect.height})"

fn grow_rect(rect: Rectangle, amount: int) -> Rectangle:
	""" Make rectangle a bit larger """
	Rectangle:
		x: rect.x - amount
		y: rect.y - amount
		width: rect.width + 2 * amount
		height: rect.height + 2 * amount

fn shrink_rect(rect: Rectangle, amount: int) -> Rectangle:
	""" Make rectangle a bit larger """
	Rectangle:
		x: rect.x + amount
		y: rect.y + amount
		width: rect.width - 2 * amount
		height: rect.height - 2 * amount

fn scale_rect(rect: Rectangle, factor: int) -> Rectangle:
	Rectangle:
		x: rect.x * factor
		y: rect.y * factor
		width: rect.width * factor
		height: rect.height * factor

fn scale_polygon(polygon: Polygon, factor: int) -> Polygon:
	let points: List[Point] = List()
	for p in polygon.path.points:
		points.append(Point(x: p.x * factor, y: p.y * factor))
	Polygon(path: Path(points))
