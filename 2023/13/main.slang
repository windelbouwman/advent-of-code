module main

from std import print, read_file, str_len
from base.utils import panic
from base.strlib import split_lines
from base.listtype import List
from base.vectype import Vector, new_vector

pub fn main() -> int:
	# let puzzle = load_data(filename: "13/example.txt")
	let grids = load_data(filename: "13/input.txt")
	part1(grids)
	part2(grids)
	0

fn part1(grids: List[Grid]):
	print("Part 1")
	var s = 0
	for grid in grids:
		s += get_reflections(grid, diff: 0)
	print("s={s}")

fn part2(grids: List[Grid]):
	print("Part 2")
	var s = 0
	for grid in grids:
		s += get_reflections(grid, diff: 1)
	print("s={s}")

fn get_reflections(grid: Grid, diff: int) -> int:
	let w = grid.get_width()
	let h = grid.get_height()

	var c = 0
	while c + 1 < w:
		if column_fold(grid, c) == diff:
			return c + 1
		c += 1

	var r = 0
	while r + 1 < h:
		if row_fold(grid, r) == diff:
			return (r + 1) * 100
		r += 1

	panic("Cannot reach here")

fn column_fold(grid: Grid, c: int) -> int:
	let w = grid.get_width()
	var c1 = c
	var c2 = c + 1
	var diff = 0
	while diff < 3 and c1 >= 0 and c2 < w:
		diff += grid.columns_diff(c1, c2)
		c1 -= 1
		c2 += 1
	diff

fn row_fold(grid: Grid, r: int) -> int:
	let h = grid.get_height()
	var r1 = r
	var r2 = r + 1
	var diff = 0
	while diff < 3 and r1 >= 0 and r2 < h:
		diff += grid.rows_diff(r1, r2)
		r1 -= 1
		r2 += 1
	diff


fn load_data(filename: str) -> List[Grid]:
	print("Loading {filename}")
	let grids: List[Grid] = List()
	let in_grid = true
	var rows: Vector[Vector[int]] = new_vector()
	for line in split_lines(text: read_file(filename)):
		if str_len(text: line) == 0:
			grids.append(Grid(rows))
			rows = new_vector()
		else:
			let cells = new_vector()
			for x in line:
				let value = if x == '#':
					0
				elif x == '.':
					1
				else:
					panic("Invalid: '{x}'")
				cells.append(value)
			rows.append(cells)
	grids.append(Grid(rows))
	grids

class Grid:
	var rows: Vector[Vector[int]]

	pub fn get_width() -> int:
		return rows[0].len()

	pub fn get_height() -> int:
		return rows.len()

	pub fn columns_diff(c1: int, c2: int) -> int:
		var diff = 0
		for row in rows:
			if row[c1] != row[c2]:
				diff += 1
		diff

	pub fn rows_diff(r1: int, r2: int) -> int:
		var diff = 0
		let row1 = rows[r1]
		let row2 = rows[r2]
		var c = 0
		while c < row1.len():
			if row1[c] != row2[c]:
				diff += 1
			c += 1
		diff
