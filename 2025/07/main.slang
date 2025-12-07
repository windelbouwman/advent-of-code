from std import print, read_file, get_arg
from strlib import trim, split_lines
from vectype import Vector, new_vector

type Diagram = Vector[str]

pub fn main() -> int:
	let diagram = read_diagram(filename: get_arg(arg: 0))
	part1(diagram)
	part2(diagram)
	0

fn read_diagram(filename: str) -> Diagram:
	let text = read_file(filename)
	let diagram: Vector[str] = new_vector()
	for line in split_lines(text):
		diagram.append(trim(text: line))
	diagram

fn part1(diagram: Diagram):
	var beams: Vector[int] = new_vector()
	let row1 = diagram[0]
	for c in row1:
		beams.append(1 if c == 'S' else 0)
	var n_splits = 0
	for row in diagram:
		var column = 0
		while column < beams.len():
			if beams[column] == 1 and row[column] == '^':
				beams.set(index: column-1, value: 1)
				beams.set(index: column, value: 0)
				beams.set(index: column+1, value: 1)
				n_splits += 1
			column += 1
	print("Part 1: {n_splits}")

fn part2(diagram: Diagram):
	var beams: Vector[int] = new_vector()
	let row1 = diagram[0]
	for c in row1:
		beams.append(1 if c == 'S' else 0)
	for row in diagram:
		var column = 0
		while column < beams.len():
			if beams[column] > 0 and row[column] == '^':
				beams.set(index: column-1, value: beams.get(index: column) + beams.get(index: column - 1))
				beams.set(index: column+1, value: beams.get(index: column) + beams.get(index: column + 1))
				beams.set(index: column, value: 0)
			column += 1
	var sum = 0
	for value in beams:
		sum += value
	print("Part 2: {sum}")
