module main

from std import print, read_file
from base.vectype import Vector, new_vector
from base.strlib import split_lines
from base.hashmap import HashMap, new_hashmap_str

pub fn main() -> int:
	print("1")
	# let grid = load_grid(filename: "14/example.txt")
	let grid = load_grid(filename: "14/input.txt")
	move_north(grid)
	print("part 1 = {calculate_load(grid)}")

	let cache: HashMap[str,int] = new_hashmap_str()
	var cycle_count = 0
	let limit = 1000000000
	while cycle_count < limit:
		cycle(grid)
		cycle_count += 1
		let key = grid.hash()
		if cache.contains(key):
			let p = cache.get(key)
			print("Cycle between: {cycle_count} and {p}")
			let delta = cycle_count - p
			let remaining = limit - cycle_count
			cycle_count += (remaining / delta) * delta
		else:
			cache.insert(key, value: cycle_count)
	print("part 2 = {calculate_load(grid)}")
	0

fn calculate_load(grid: Grid) -> int:
	var s = 0

	var row = 0
	let h = grid.get_height()
	let w = grid.get_width()

	while row < h:
		var col = 0
		while col < w:
			if grid.get(row, col) == 'O':
				s += h - row
			col += 1
		row += 1
	s

fn cycle(grid: Grid):
	move_north(grid)
	move_west(grid)
	move_south(grid)
	move_east(grid)

fn move_north(grid: Grid):
	let h = grid.get_height()
	let w = grid.get_width()
	var col = 0
	while col < w:
		var row = 1
		while row < h:
			if grid.get(row, col) == 'O':
				var row2 = row
				while row2 > 0:
					if grid.get(row: row2 - 1, col) == '.':
						grid.set(row: row2, col, value: '.')
						grid.set(row: row2 - 1, col, value: 'O')
					else:
						break
					row2 -= 1
			row += 1
		col += 1

fn move_south(grid: Grid):
	let h = grid.get_height()
	let w = grid.get_width()
	var col = 0
	while col < w:
		var row = h - 2
		while row >= 0:
			if grid.get(row, col) == 'O':
				var row2 = row
				while row2 + 1 < h:
					if grid.get(row: row2 + 1, col) == '.':
						grid.set(row: row2, col, value: '.')
						grid.set(row: row2 + 1, col, value: 'O')
					else:
						break
					row2 += 1
			row -= 1
		col += 1

fn move_west(grid: Grid):
	let h = grid.get_height()
	let w = grid.get_width()
	var row = 0
	while row < h:
		var col = 1
		while col < w:
			if grid.get(row, col) == 'O':
				var col2 = col
				while col2 > 0:
					if grid.get(row, col: col2 - 1) == '.':
						grid.set(row, col: col2, value: '.')
						grid.set(row, col: col2 - 1, value: 'O')
					else:
						break
					col2 -= 1
			col += 1
		row += 1

fn move_east(grid: Grid):
	let h = grid.get_height()
	let w = grid.get_width()
	var row = 0
	while row < h:
		var col = w - 2
		while col >= 0:
			if grid.get(row, col) == 'O':
				var col2 = col
				while col2 + 1 < w:
					if grid.get(row, col: col2 + 1) == '.':
						grid.set(row, col: col2, value: '.')
						grid.set(row, col: col2 + 1, value: 'O')
					else:
						break
					col2 += 1
			col -= 1
		row += 1

fn load_grid(filename: str) -> Grid:
	let rows: Vector[Vector[char]] = new_vector()
	let lines = split_lines(text: read_file(filename))
	for line in lines:
		let row: Vector[char] = new_vector()
		for c in line:
			row.append(c)
		rows.append(row)

	Grid(rows)

class Grid:
	var rows: Vector[Vector[char]]

	pub fn get_width() -> int:
		rows[0].len()

	pub fn get_height() -> int:
		rows.len()

	pub fn get(row: int, col: int) -> char:
		rows[row][col]

	pub fn set(row: int, col: int, value: char):
		rows[row].set(index: col, value)

	fn repr() -> str:
		var txt = ""
		for row in rows:
			for c in row:
				txt = txt + "{c}"
		txt

	pub fn hash() -> str:
		repr()

	fn dump():
		for row in rows:
			var txt = ""
			for c in row:
				txt = txt + "{c}"
			print(txt)
		print("")
