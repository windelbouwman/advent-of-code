module main

from std import print, read_file, str_slice, str_len
from base.strlib import split_string, str_to_int, trim
from base.hashmap import HashMap, new_hashmap
from base.functools import map
from base.listtype import List

pub fn main() -> int:
	let numbers = load_numbers(filename: "11/input.txt")
	# let numbers = load_numbers(filename: "11/example.txt")
	part1(numbers)
	part2(numbers)
	0

fn part1(numbers: List[int]):
	print("Part1: {blink(numbers, N: 25)}")

fn part2(numbers: List[int]):
	print("Part2: {blink(numbers, N: 75)}")

fn blink(numbers: List[int], N: int) -> int:
	let cache: HashMap[State,int] = new_hashmap(f_hash: state_hash, f_eq: state_eq)
	var s = 0
	for x in numbers:
		s += amount(cache, x, N)
	s

fn amount(cache: HashMap[State,int], x: int, N: int) -> int:
	"""Blink the number x N times, and return how many stones this will create."""
	if N > 0:
		let s = State(x, N)
		if cache.contains(key: s):
			cache.get(key: s)
		else:
			let text = "{x}"
			let w = str_len(text)
			let value = if x == 0:
				amount(cache, x: 1, N: N - 1)
			elif w & 1 == 0:
				let left = str_to_int(str_slice(text, begin: 0, end: w / 2))
				let right = str_to_int(str_slice(text, begin: w / 2, end: w))
				amount(cache, x: left, N: N - 1) + amount(cache, x: right, N: N - 1)
			else:
				amount(cache, x: x * 2024, N: N - 1)
			cache.insert(key: s, value)
			value
	else:
		1

struct State:
	x: int
	N: int

fn state_hash(s?: State) -> uint32:
	let value = s.x * 7919 + s.N
	uint32(value)

fn state_eq(s1?: State, s2?: State) -> bool:
	s1.x == s2.x and s1.N == s2.N

fn load_numbers(filename: str) -> List[int]:
	let line = trim(text: read_file(filename))
	map(values: split_string(text: line, sep: ' '), function: str_to_int)
