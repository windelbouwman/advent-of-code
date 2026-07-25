module main

from std import read_file, ord, str_len, print, str_slice
from base.utils import assert
from base.strlib import split_lines, split_string, str_to_int
from base.listtype import List
from base.math import modulo

pub fn main() -> int:
	# let filename = "example.txt"
	let filename = "input.txt"
	let puzzle = load_puzzle(filename)
	# part1(puzzle)
	part2(puzzle)
	0

fn load_puzzle(filename: str) -> Puzzle:
	let lines = split_lines(text: read_file(filename))
	let line = lines.get(index: 0)
	let items = split_string(text: line, sep: ',')
	return Puzzle(items)

fn part1(puzzle: Puzzle):
	var s = 0
	for item in puzzle.items:
		s += hash(text: item)
	print("Part 1: {s}")

fn part2(puzzle: Puzzle):
	let hash_map = HashMap()
	hash_map.init()
	for text in puzzle.items:
		let parts = split_string(text, sep: '=')
		if parts.len() == 2:
			# Insert!
			let label = parts.get(index: 0)
			let strength = str_to_int(parts.get(index: 1))
			print("Insert {label} = {strength}")
			hash_map.insert(label, strength)
		else:
			let n = str_len(text)
			let label = str_slice(text, begin: 0, end: n - 1)
			print("Remove {label}")
			hash_map.delete(label)

	var s = 0
	var i = 0
	for boks in hash_map.boxes:
		i += 1
		var j = 0
		for lens in boks.lenses:
			j += 1
			let power = i * j * lens.strength
			s += power
	print("Part 2: {s}")

struct Lens:
	label: str
	strength: int

struct Box:
	lenses: List[Lens]

class HashMap:
	pub var boxes: List[Box] = List()

	pub fn init():
		var i = 0
		while i < 256:
			i += 1
			boxes.append(Box(lenses: List()))
		assert(condition: boxes.len() == 256, message: "Expect 256 boxes")

	pub fn insert(label: str, strength: int):
		let index = hash(text: label)
		let boks = boxes.get(index)
		for lens in boks.lenses:
			if lens.label == label:
				lens.strength = strength
				return
		boks.lenses.append(Lens(label, strength))

	pub fn delete(label: str):
		let index = hash(text: label)
		let boks = boxes.get(index)
		var del_index = -1
		var i = 0
		for lens in boks.lenses:
			if lens.label == label:
				del_index = i
				break
			else:
				i += 1
		if del_index >= 0:
			boks.lenses.delete_at(index: del_index)


fn hash(text: str) -> int:
	var h = 0
	for c in text:
		h = (h + ord(c)) * 17
		h = modulo(value: h, divisor: 256)
	return h

struct Puzzle:
	items: List[str]
