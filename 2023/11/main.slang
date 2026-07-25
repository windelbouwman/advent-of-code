module main

from std import print, read_file, str_len
from base.strlib import split_lines
from base.listtype import List

pub fn main() -> int:
	# let filename = "example.txt"
	let filename = "input.txt"
	let puzzle = load_input(filename)
	part1(puzzle)
	0

fn load_input(filename: str) -> Puzzle:
	let galaxies: List[Point] = List()
	var row = 0
	var x_max = 0

	for line in split_lines(text: read_file(filename)):
		var col = 0
		let n = str_len(text: line)
		if n > x_max:
			x_max = n
		while col < n:
			let c = line[col]
			if c == '#':
				galaxies.append(Point(x: col, y: row))
			col += 1
		row += 1
	let y_max = row
	print("Dimensions: {x_max}x{y_max}")
	Puzzle(galaxies, x_max, y_max)

struct Point:
	x: int
	y: int

struct Puzzle:
	galaxies: List[Point]
	x_max: int
	y_max: int

fn part1(puzzle: Puzzle):
	# step 1: Find empty rows and columns
	let x_distances: List[int] = List()
	let y_distances: List[int] = List()

	var d = 0
	while d <= puzzle.x_max or d <= puzzle.y_max:
		var x_empty = true
		var y_empty = true
		for galaxy in puzzle.galaxies:
			if galaxy.x == d:
				x_empty = false
			if galaxy.y == d:
				y_empty = false

		if x_empty:
			x_distances.append(1000000)
		else:
			x_distances.append(1)

		if y_empty:
			y_distances.append(1000000)  # Part 1=2, part2=1000000
		else:
			y_distances.append(1)

		d += 1

	# step 2: Find pairs, and distances
	var s = 0
	var index1 = 0
	let n = puzzle.galaxies.len()
	while index1 < n:
		let galaxy1 = puzzle.galaxies.get(index: index1)
		var index2 = index1 + 1
		while index2 < n:
			let galaxy2 = puzzle.galaxies.get(index: index2)

			# Determine distance:
			let dx = distance(a: galaxy1.x, b: galaxy2.x, distances: x_distances)
			let dy = distance(a: galaxy1.y, b: galaxy2.y, distances: y_distances)
			s += dy + dx

			index2 += 1
		index1 += 1
	print("Sum = {s}")

fn distance(a: int, b: int, distances: List[int]) -> int:
	var x1 = a
	var x2 = b
	if x1 > x2:
		x1 = b
		x2 = a
	var dx = 0
	while x1 < x2:
		dx += distances.get(index: x1)
		x1 += 1
	return dx
