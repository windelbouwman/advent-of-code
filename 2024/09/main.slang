module main

from std import print, read_file
from base.strlib import digit_to_int, trim
from base.listtype import List
from base.vectype import Vector, new_vector, new_vector_of_size

pub fn main() -> int:
	let puzzle = load_puzzle(filename: "09/input.txt")
	# let puzzle = load_puzzle(filename: "09/example.txt")
	part1(puzzle)
	part2(puzzle)
	0

fn part1(puzzle: Vector[int]):
	var is_file = true
	let spaces: List[Block] = List()
	let files: List[File] = List()
	var index = 0
	var id = 0
	for size in puzzle:
		let block = Block(index, size)
		if is_file:
			files.append(File(id, block))
			id += 1
		else:
			spaces.append(block)
		index += size
		is_file = not is_file

	let disk_size = index

	# Create sectors:
	let sectors: Vector[int] = new_vector_of_size(size: disk_size, default: -1)
	for file in files:
		var i = 0
		while i < file.block.size:
			sectors.set(index: file.block.index + i, value: file.id)
			i += 1

	var free_index = 0
	var file_index = disk_size - 1
	loop:
		while sectors[free_index] != -1:
			free_index += 1
		while sectors[file_index] == -1:
			file_index -= 1

		if free_index < file_index:
			# Swap:
			let x = sectors[file_index]
			sectors.set(index: file_index, value: sectors[free_index])
			sectors.set(index: free_index, value: x)
		else:
			break

	# Calculate CRC
	var s = 0
	var i = 0
	while i < sectors.len():
		let n = sectors[i]
		if n >= 0:
			# if n > 0 and i > file_index:
			# print("i={i} n={n}")
			s += n * i
		i += 1

	print("Part1: {s}")

fn part2(puzzle: Vector[int]):
	# Determine files and free blocks:
	var is_file = true
	let spaces: List[Block] = List()
	let files: List[File] = List()
	var index = 0
	var id = 0
	for size in puzzle:
		let block = Block(index, size)
		if is_file:
			# print("n={size} id={id}")
			files.append(File(id, block))
			id += 1
		else:
			spaces.append(block)
		index += size
		is_file = not is_file

	# Try to move each file once starting with the last file
	for file in files.reversed():
		for space in spaces:
			if space.index > file.block.index:
				break
			if file.block.size <= space.size:
				# Move block!
				file.block.index = space.index
				# Shrink free space:
				space.index += file.block.size
				space.size -= file.block.size
				# Move block:
				break

	# Calculate CRC
	var crc = 0
	for file in files:
		var i = 0
		while i < file.block.size:
			crc += (file.block.index + i) * file.id
			i += 1

	print("Part2: {crc}")

struct Block:
	index: int
	size: int

struct File:
	id: int
	block: Block

fn load_puzzle(filename: str) -> Vector[int]:
	let line = trim(text: read_file(filename))
	let numbers: Vector[int] = new_vector()
	for c in line:
		numbers.append(digit_to_int(c))
	numbers
