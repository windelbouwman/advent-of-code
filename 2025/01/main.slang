
from std import print, read_file, str_len, str_get, str_slice, get_arg
from strlib import split_lines, str_to_int
from math import modulo, abs
from listtype import List

struct Pair:
	c: char
	n: int

pub fn main() -> int:
	let pairs = load_pairs(filename: get_arg(arg: 0))
	part1(pairs)
	part2(pairs)
	0

fn load_pairs(filename: str) -> List[Pair]:
	let pairs: List[Pair] = List()
	for line in split_lines(text: read_file(filename)):
		let c = str_get(text: line, index: 0)
		let n = str_to_int(str_slice(text: line, begin: 1, end: str_len(text: line)))
		pairs.append(Pair(c, n))
	pairs

fn part1(pairs: List[Pair]):
	var x = 50
	var count = 0
	for pair in pairs:
		if pair.c == 'L':
			x -= pair.n
		elif pair.c == 'R':
			x += pair.n
		if modulo(value: x, divisor: 100) == 0:
			count += 1
	print("Part 1: {count}")

fn part2(pairs: List[Pair]):
	var x = 50
	var count = 0
	for pair in pairs:
		if pair.c == 'L':
			var i = 0
			while i < pair.n:
				x -= 1
				i += 1
				if modulo(value: x, divisor: 100) == 0:
					count += 1
		elif pair.c == 'R':
			var i = 0
			while i < pair.n:
				x += 1
				i += 1
				if modulo(value: x, divisor: 100) == 0:
					count += 1
	print("Part 2: {count}")
