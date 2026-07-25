module main

from std import print, read_file
from base.utils import panic
from base.math import max
from base.listtype import List
from base.vectype import Vector, new_vector
from base.strlib import split_lines

pub fn main() -> int:
	# let grid = load_grid(filename: "16/example.txt")
	let grid = load_grid(filename: "16/input.txt")
	# grid.dump()
	ray_trace(grid, row: 0, col: 0, direction: Direction.Right())
	# grid.dump()
	print("part1: {count_energized(grid)}")

	var s = 0
	let w = grid.get_width()
	let h = grid.get_height()
	var row = 0
	while row < h:
		s = max(s, energize(grid, row, col: 0, direction: Direction.Right()))
		s = max(s, energize(grid, row, col: w - 1, direction: Direction.Left()))
		row += 1
	var col = 0
	while col < w:
		s = max(s, energize(grid, row: 0, col, direction: Direction.Down()))
		s = max(s, energize(grid, row: h - 1, col, direction: Direction.Up()))
		col += 1
	print("Part 2: {s}")
	0

fn energize(grid: Grid, row: int, col: int, direction: Direction) -> int:
	grid.reset()
	ray_trace(grid, row, col, direction)
	count_energized(grid)

fn count_energized(grid: Grid) -> int:
	var s = 0
	for row in grid.rows:
		for c in row:
			if c.energized:
				s += 1
	s

fn ray_trace(grid: Grid, row: int, col: int, direction: Direction):
	let w = grid.get_width()
	let h = grid.get_height()

	let rays: List[Ray] = List()
	rays.append(Ray(row, col, direction))
	while not rays.is_empty():
		# print("Trace")
		let ray = rays.pop_front()
		while ray.row >= 0 and ray.row < h and ray.col >= 0 and ray.col < w:
			let c = grid.get(row: ray.row, col: ray.col)
			case ray.direction:
				Up:
					if c.up:
						break
					else:
						c.up = true
				Down:
					if c.down:
						break
					else:
						c.down = true
				Left:
					if c.left:
						break
					else:
						c.left = true
				Right:
					if c.right:
						break
					else:
						c.right = true
			c.energized = true

			if c.c == '.':
				pass
			elif c.c == '|':
				case ray.direction:
					Up:
						pass
					Down:
						pass
					Left:
						ray.direction = Direction.Up()
						let ray2 = Ray(row: ray.row, col: ray.col, direction: Direction.Down())
						rays.append(ray2)
					Right:
						ray.direction = Direction.Up()
						let ray2 = Ray(row: ray.row, col: ray.col, direction: Direction.Down())
						rays.append(ray2)
			elif c.c == '-':
				case ray.direction:
					Up:
						ray.direction = Direction.Left()
						let ray2 = Ray(row: ray.row, col: ray.col, direction: Direction.Right())
						rays.append(ray2)
					Down:
						ray.direction = Direction.Left()
						let ray2 = Ray(row: ray.row, col: ray.col, direction: Direction.Right())
						rays.append(ray2)
					Left:
						pass
					Right:
						pass
			elif c.c == '/':
				case ray.direction:
					Up:
						ray.direction = Direction.Right()
					Down:
						ray.direction = Direction.Left()
					Left:
						ray.direction = Direction.Down()
					Right:
						ray.direction = Direction.Up()
			elif c.c == '\\':
				case ray.direction:
					Up:
						ray.direction = Direction.Left()
					Down:
						ray.direction = Direction.Right()
					Left:
						ray.direction = Direction.Up()
					Right:
						ray.direction = Direction.Down()
			else:
				panic("Cannot {c.c}")

			step(ray)
			# print("Ray: {ray.row},{ray.col}")

fn load_grid(filename: str) -> Grid:
	let rows: Vector[Vector[Cell]] = new_vector()
	let lines = split_lines(text: read_file(filename))
	for line in lines:
		let row: Vector[Cell] = new_vector()
		for c in line:
			row.append(Cell(c, up: false, down: false, left: false, right: false, energized: false))
		rows.append(row)
	Grid(rows)

struct Ray:
	row: int
	col: int
	direction: Direction

fn step(ray: Ray):
	case ray.direction:
		Up:
			ray.row -= 1
		Down:
			ray.row += 1
		Left:
			ray.col -= 1
		Right:
			ray.col += 1

enum Direction:
	Up
	Down
	Left
	Right

struct Cell:
	c: char
	up: bool
	down: bool
	left: bool
	right: bool
	energized: bool

class Grid:
	pub var rows: Vector[Vector[Cell]]

	pub fn get_width() -> int:
		rows[0].len()

	pub fn get_height() -> int:
		rows.len()

	pub fn get(row: int, col: int) -> Cell:
		rows[row][col]

	fn dump():
		for row in rows:
			var txt = ""
			for c in row:
				if c.energized:
					txt = txt + "#"
				else:
					txt = txt + "{c.c}"
			print(txt)
		print("")

	pub fn reset():
		for row in rows:
			for c in row:
				c.energized = false
				c.up = false
				c.down = false
				c.left = false
				c.right = false
