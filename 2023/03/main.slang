module main

from std import print, read_file, str_len, str_slice
from base.strlib import split_lines, is_digit, str_to_int
from base.listtype import List
from aoclib import Range, ranges_overlap


pub fn main():
	# let schematic = load_data(filename: "example.txt")
	let schematic = load_data(filename: "input.txt")
	part1(schematic)
	part2(schematic)

fn part1(schematic: Schematic):
	print("Part 1")
	for symbol in schematic.symbols:
		let row_range1 = Range(begin: symbol.row - 1, end: symbol.row + 1)
		let column_range1 = Range(begin: symbol.column - 1, end: symbol.column + 1)
		for label in schematic.labels:
			let row_range2 = Range(begin: label.row, end: label.row)
			let column_range2 = Range(begin: label.column, end: label.column + str_len(text: "{label.number}") - 1)

			if ranges_overlap(self: row_range1, other: row_range2):
				if ranges_overlap(self: column_range1, other: column_range2):
					print("touch: {symbol.symbol}: {label.number}")
					symbol.labels.append(label.number)

	var sum = 0
	for symbol in schematic.symbols:
		for label in symbol.labels:
			sum += label
	print("Sum: {sum}")

fn part2(schematic: Schematic):
	var sum = 0
	for symbol in schematic.symbols:
		if symbol.labels.len() == 2:
			var ratio = 1
			for label in symbol.labels:
				ratio = ratio * label
			sum += ratio
	print("Part 2: {sum}")

fn load_data(filename: str) -> Schematic:
	let labels: List[Label] = List()
	let symbols: List[Symbol] = List()
	var row = 0
	for line in split_lines(text: read_file(filename)):
		let n = str_len(text: line)
		var i = 0
		while i < n:
			var c = line[i]
			if is_digit(c):
				let j = i
				i += 1
				while i < n:
					c = line[i]
					if is_digit(c):
						i += 1
					else:
						break
				let num = str_slice(text: line, begin: j, end: i)
				print("Number {num} at {row},{j}")
				let label = Label(number: str_to_int(num), row, column: j)
				labels.append(label)
			elif c == '.':
				i += 1
			else:
				# Symbol!
				print("Symbol: {c} @ {row},{i}")
				let sym = Symbol(symbol: c, row, column: i, labels: List())
				symbols.append(sym)
				i += 1
		row += 1
	return Schematic(labels, symbols)

struct Symbol:
	symbol: char
	row: int
	column: int
	labels: List[int]

struct Label:
	number: int
	row: int
	column: int

struct Schematic:
	labels: List[Label]
	symbols: List[Symbol]
