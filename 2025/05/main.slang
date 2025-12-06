from std import print, read_file, str_slice, str_len, get_arg
from strlib import trim, split_string, str_to_int, split_lines
from sorting import sort_list
from math import modulo, max
from listtype import List
from utils import panic

struct Puzzle:
	ranges: List[Range2]
	available: List[int]

struct Range2:
	lower: int
	upper: int

pub fn main() -> int:
	let puzzle = read_puzzle(filename: get_arg(arg: 0))
	part1(puzzle)
	part2(puzzle)
	0

fn read_puzzle(filename: str) -> Puzzle:
	let text = read_file(filename)
	var section = 0
	let ranges: List[Range2] = List()
	let available: List[int] = List()
	for line2 in split_lines(text):
		# parse line into Range and add to list
		let line = trim(line2)
		if line == "":
			section += 1
		else:
			if section == 0:
				let parts = split_string(text: line, sep: '-')
				let lower = str_to_int(parts[0])
				let upper = str_to_int(parts[1])
				ranges.append(Range2(lower, upper))
			elif section == 1:
				let id = str_to_int(line)
				available.append(id)
			else:
				panic("Unexpected line after two sections: {line}")
	Puzzle(ranges, available)

fn part1(puzzle: Puzzle):
	var n = 0
	for id in puzzle.available:
		if is_range(id, ranges: puzzle.ranges):
			n += 1
	print("Part 1: {n}")

fn is_range(id: int, ranges: List[Range2]) -> bool:
	for range in ranges:
		if id >= range.lower and id <= range.upper:
			return true
	false

fn part2(puzzle: Puzzle):
	let ranges: List[Range2] = sort_list(puzzle.ranges, cmp: cmp_ranges)
	var end = 0
	var count = 0
	for range in ranges:
		# print("Adding range {range.lower} - {range.upper}")
		let start = max(end + 1, range.lower)
		end = max(end, range.upper)
		if start <= end:
			count += (end - start) + 1
	print("Part 2: {count}")

fn cmp_ranges(a: Range2, b: Range2) -> bool:
	if a.lower == b.lower:
		a.upper < b.upper
	else:
		return a.lower < b.lower
