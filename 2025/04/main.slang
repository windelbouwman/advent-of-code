from std import print, read_file, str_slice, str_len, ord, get_arg
from strlib import trim, split_string, str_to_int, split_lines
from math import modulo
from regex import split_at_pattern
from listtype import List
from vectype import Vector, new_vector
from utils import panic

struct Grid:
	width: int
	height: int
	data: Vector[Vector[char]]

pub fn main() -> int:
	let grid = read_grid(filename: get_arg(arg: 0))
	part1(grid)
	part2(grid)
	0

fn read_grid(filename: str) -> Grid:
	let text = read_file(filename)
	let data: Vector[Vector[char]] = new_vector()
	for line in split_lines(text):
		let row: Vector[char] = new_vector()
		for c in trim(line):
			row.append(c)
		data.append(row)
	Grid(width: data[0].len(), height: data.len(), data)

fn part1(grid: Grid):
	var sum = 0
	var x = 0
	while x < grid.width:
		var y = 0
		while y < grid.height:
			if is_roll(grid, x, y):
				if num_neighbours(grid, x, y) < 4:
					sum += 1
			y += 1
		x += 1
	print("Part 1: {sum}")

fn part2(grid: Grid):
	var sum = 0
	var change = true
	while change:
		change = false
		var x = 0
		while x < grid.width:
			var y = 0
			while y < grid.height:
				if is_roll(grid, x, y):
					if num_neighbours(grid, x, y) < 4:
						remove_roll(grid, x, y)
						sum += 1
						change = true
				y += 1
			x += 1
	print("Part 2: {sum}")

fn num_neighbours(grid: Grid, x: int, y: int) -> int:
	var num = 0
	if is_roll(grid, x: x - 1, y: y - 1):
		num += 1
	if is_roll(grid, x: x, y: y - 1):
		num += 1
	if is_roll(grid, x: x + 1, y: y - 1):
		num += 1
	if is_roll(grid, x: x - 1, y):
		num += 1
	if is_roll(grid, x: x + 1, y):
		num += 1
	if is_roll(grid, x: x - 1, y: y + 1):
		num += 1
	if is_roll(grid, x: x, y: y + 1):
		num += 1
	if is_roll(grid, x: x + 1, y: y + 1):
		num += 1
	num

fn is_roll(grid: Grid, x: int, y: int) -> bool:
	if x < 0 or x >= grid.width:
		false
	elif y < 0 or y >= grid.height:
		false
	else:
		grid.data[y][x] == '@'

fn remove_roll(grid: Grid, x: int, y: int):
	grid.data[y].set(index: x, value: '.')
