module main

from std import read_file, print, str_get, str_len
from base.strlib import split_lines, split_string
from base.listtype import List
from base.hashmap import HashMap, new_hashmap_str
from aoclib import get_numbers

pub fn main() -> int:
	# let puzzle = load_data(filename: "12/example1.txt")
	let puzzle = load_data(filename: "12/input.txt")
	part1(puzzle)
	part2(puzzle)
	0

fn part1(puzzle: Puzzle):
	print("Part 1")
	var s = 0
	for row in puzzle.rows:
		let cache: HashMap[str,int] = new_hashmap_str()
		s += try_combo_2(cache, row, start: 0, group: 0)
	print("Sum: {s}")

fn part2(puzzle: Puzzle):
	print("Part 2")
	puzzle = unfold(puzzle)
	part1(puzzle)

fn unfold(puzzle: Puzzle) -> Puzzle:
	let rows = List()
	for row in puzzle.rows:
		var n = 0
		var pattern = row.pattern
		let damaged = List()
		damaged.extend2(row.damaged)
		while n < 4:
			pattern = pattern + "?" + row.pattern
			damaged.extend2(row.damaged)
			n += 1
		rows.append(Row(pattern, damaged))
	Puzzle(rows)

fn try_combo_2(cache: HashMap[str,int], row: Row, start: int, group: int) -> int:
	let key = "{start},{group}"

	if cache.contains(key):
		cache.get(key)
	else:
		var x = 0
		let n = str_len(text: row.pattern)

		# If we processed all groups,
		# ensure no more damaged springs occur
		if group >= row.damaged.len():
			x = 1
			while start < n:
				if str_get(text: row.pattern, index: start) == '#':
					x = 0
				start += 1
		else:
			let size = row.damaged[group]

			while start + size <= n:
				if can_fit(pattern: row.pattern, start, size):
					x += try_combo_2(cache, row, start: start + size + 1, group: group + 1)
				let c = str_get(text: row.pattern, index: start)
				if c == '?' or c == '.':
					start += 1
				else:
					break
		cache.insert(key, value: x)
		x

fn can_fit(pattern: str, start: int, size: int) -> bool:
	"""Can we fit a group at the given start position?
	'#' = damaged
	'.' = operational
	'?' = unknown
	"""
	var index = start
	let n = str_len(text: pattern)
	if index + size > n:
		return false
	while size > 0:
		let c = str_get(text: pattern, index)
		if c == '?' or c == '#':
			index += 1
			size -= 1
		else:
			return false

	# Check for end of string or operational spring:
	if index < n:
		let c = str_get(text: pattern, index)
		c == '?' or c == '.'
	else:
		true

fn load_data(filename: str) -> Puzzle:
	print("Loading {filename}")
	let rows: List[Row] = List()
	for line in split_lines(text: read_file(filename)):
		let parts = split_string(text: line, sep: ' ')
		let pattern = parts[0]
		let damaged = get_numbers(text: parts[1], sep: ',')
		let row = Row(pattern, damaged)
		rows.append(row)

	Puzzle(rows)

struct Puzzle:
	rows: List[Row]

struct Row:
	pattern: str
	damaged: List[int]
