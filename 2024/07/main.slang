module main

from std import print, read_file
from base.strlib import split_lines, str_to_int, split_string, trim
from base.functools import map
from base.listtype import List

pub fn main() -> int:
	let equations = load_equations(filename: "07/input.txt")
	# let equations = load_equations(filename: "07/example.txt")
	part(1, equations)
	part(2, equations)
	0

fn part(part?: int, equations: List[Equation]):
	let use_concatenation = part == 2
	var s = 0
	for equation in equations:
		if is_valid(equation, use_concatenation):
			s += equation.result
	print("Part{part}: {s}")

fn is_valid(equation: Equation, use_concatenation: bool) -> bool:
	let w: List[State] = List()
	w.append(State(index: 1, value: equation.values[0]))
	while not w.is_empty():
		let s = w.pop_front()
		if s.index < equation.values.len():
			if s.value <= equation.result:
				w.append(State(index: s.index + 1, value: s.value + equation.values[s.index]))
				w.append(State(index: s.index + 1, value: s.value * equation.values[s.index]))
				if use_concatenation:
					let value = str_to_int("{s.value}{equation.values[s.index]}")
					w.append(State(index: s.index + 1, value))
		else:
			if s.value == equation.result:
				return true
	false

struct State:
	index: int
	value: int

fn load_equations(filename: str) -> List[Equation]:
	let equations: List[Equation] = List()
	let lines = split_lines(text: read_file(filename))
	for line in lines:
		let parts = split_string(text: line, sep: ':')
		let result = str_to_int(parts[0])
		let values = map(values: split_string(text: trim(parts[1]), sep: ' '), function: str_to_int)
		equations.append(Equation(result, values))
	equations

struct Equation:
	result: int
	values: List[int]
