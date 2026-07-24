module main

from std import print, read_file, str_slice, str_len
from base.strlib import split_lines, split_string
from base.listtype import List
from base.heapq import PriorityQueue, new_int_min_queue
from base.regex import split_at_pattern
from base.math import max
from base.settype import Set, new_str_set, new_int_set
from base.vectype import Vector, new_vector_of_size

pub fn main() -> int:
	solve(filename: "19/example.txt")
	solve(filename: "19/input.txt")
	0

fn solve(filename: str):
	let puzzle = load_puzzle(filename)
	let towel_set = new_str_set()
	var M = 1
	for towel in puzzle.towels:
		M = max(M, str_len(text: towel))
		towel_set.add(towel)
	var s1 = 0
	var s2 = 0
	for pattern in puzzle.patterns:
		let x = num_options(pattern, towel_set, M)
		if x > 0:
			s1 += 1
		s2 += x

	print("[{filename}] Part 1: {s1}")
	print("[{filename}] Part 2: {s2}")

fn num_options(pattern: str, towel_set: Set[str], M: int) -> int:
	let visited = new_int_set()
	let N = str_len(text: pattern)
	let reach_counts: Vector = new_vector_of_size(size: N + 1, default: 0)
	let Q: PriorityQueue[int] = new_int_min_queue()
	reach_counts.set(index: 0, value: 1)
	Q.push(0)
	while not Q.is_empty():
		let begin = Q.pop()
		if not visited.contains(begin):
			visited.add(begin)

			var size = 0
			while size < M:
				size += 1
				let end = begin + size
				if end <= N:
					let part = str_slice(text: pattern, begin, end)
					if towel_set.contains(part):
						Q.push(end)
						reach_counts.set(index: end, value: reach_counts[end] + reach_counts[begin])
	reach_counts[N]

fn load_puzzle(filename: str) -> Puzzle:
	var towels: List[str] = List()
	let patterns: List[str] = List()
	var row = 0
	for line in split_lines(text: read_file(filename)):
		let parts = split_string(text: line, sep: ',')
		row += 1
		if row == 1:
			towels = split_at_pattern(text: line, pattern: ", ")
		elif row > 2:
			patterns.append(line)
	Puzzle(towels, patterns)

struct Puzzle:
	towels: List[str]
	patterns: List[str]
