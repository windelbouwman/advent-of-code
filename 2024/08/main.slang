module main

from std import print, read_file, str_len
from base.strlib import split_lines
from base.settype import new_str_set
from base.hashmap import new_hashmap_char, HashMap
from base.listtype import List

pub fn main() -> int:
	let puzzle = load_puzzle(filename: "08/input.txt")
	# let puzzle = load_puzzle(filename: "08/example.txt")
	part1(puzzle)
	part2(puzzle)
	0

fn part1(puzzle: Puzzle):
	let antinodes = new_str_set()
	for x in puzzle.m:
		let positions = puzzle.m.get(key: x)
		for pos1 in positions:
			for pos2 in positions:
				if not position_equal(pos1, pos2):
					let d = sub_position(pos1, pos2)
					let pos3 = add_position(pos1, d)
					if pos3.row >= 0 and pos3.row < puzzle.height and pos3.col >= 0 and pos3.col < puzzle.width:
						let key = "{pos3.row},{pos3.col}"
						antinodes.add(key)
	print("Part1: {antinodes.len()}")

fn part2(puzzle: Puzzle):
	let antinodes = new_str_set()
	for x in puzzle.m:
		let positions = puzzle.m.get(key: x)
		for pos1 in positions:
			for pos2 in positions:
				if not position_equal(pos1, pos2):
					let d = sub_position(pos1, pos2)
					var pos3 = pos1
					loop:
						if pos3.row >= 0 and pos3.row < puzzle.height and pos3.col >= 0 and pos3.col < puzzle.width:
							let key = "{pos3.row},{pos3.col}"
							antinodes.add(key)
							pos3 = add_position(pos3, d)
						else:
							break
	print("Part2: {antinodes.len()}")

fn load_puzzle(filename: str) -> Puzzle:
	let lines = split_lines(text: read_file(filename))
	let width = str_len(text: lines[0])
	let height = lines.len()
	let m: HashMap[char,List[Position]] = new_hashmap_char()
	var row = 0
	for line in lines:
		var col = 0
		for c in line:
			if c != '.':
				if not m.contains(key: c):
					m.insert(key: c, value: List())
				let pos = Position(row, col)
				m.get(key: c).append(pos)
			col += 1
		row += 1
	Puzzle(width, height, m)

struct Puzzle:
	width: int
	height: int
	m: HashMap[char,List[Position]]

struct Position:
	row: int
	col: int

fn position_equal(a?: Position, b?: Position) -> bool:
	a.row == b.row and a.col == b.col

fn sub_position(a?: Position, b?: Position) -> Position:
	let row = a.row - b.row
	let col = a.col - b.col
	Position(row, col)

fn add_position(a?: Position, b?: Position) -> Position:
	let row = a.row + b.row
	let col = a.col + b.col
	Position(row, col)
