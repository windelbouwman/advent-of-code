module main

from std import print, read_file
from base.strlib import split_lines, str_to_int, trim, str_join
from rt import int_to_str
from base.utils import panic
from base.regex import find_all, find, Match
from base.functools import map
from base.listtype import List
from base.optiontype import option_unwrap
from base.vectype import Vector, new_vector


pub fn main() -> int:
	# part_1(filename: "17/example.txt")
	part_1(filename: "17/input.txt")
	# part_2(filename: "17/example2.txt")
	part_2(filename: "17/input.txt")
	0

fn part_1(filename: str):
	let machine = load_machine(filename)
	let output = run_machine(machine)
	let text = str_join(parts: map(values: output, function: int_to_str), sep: ",")
	print("Part1: {text}")

fn run_machine(machine: Machine) -> List[int]:
	let output: List[int] = List()
	while machine.pc + 1 < machine.code.len():
		let opcode = machine.code[machine.pc]
		let operand = machine.code[machine.pc + 1]
		machine.pc += 2
		switch opcode:
			0:  # adv
				machine.A = machine.A / (1 << combo(machine, operand))
			1:  # bxl
				machine.B = machine.B ^ operand
			2:  # bst
				machine.B = modulo8(combo(machine, operand))
			3:  # jnz
				if machine.A != 0:
					machine.pc = operand
			4:  # bxc
				machine.B = machine.B ^ machine.C
			5:  # out
				output.append(modulo8(combo(machine, operand)))
			6:  # bdv
				machine.B = machine.A / (1 << combo(machine, operand))
			7:  # cdv
				machine.C = machine.A / (1 << combo(machine, operand))
		else:
			panic("Invalid operand: {opcode}!")
	output

fn combo(machine: Machine, operand: int) -> int:
	switch operand:
		4:
			machine.A
		5:
			machine.B
		6:
			machine.C
		7:
			panic("Invalid operand 7!")
	else:
		operand

fn modulo8(x?: int) -> int:
	x & 7

fn part_2(filename: str):
	let machine = load_machine(filename)
	# Assume we run an assembly code loop, dividing A by 8 each loop (adv A = A / 8 opcode 0,3)
	# find A from looking at the last number back to the front:
	var digit = machine.code.len() - 1
	var A = 0
	while digit >= 0:
		A = A * 8
		var i = 0
		loop:
			machine.A = A + i
			machine.B = 0
			machine.C = 0
			machine.pc = 0
			let output = run_machine(machine)
			if not output.is_empty():
				if output[0] == machine.code[digit]:
					A = A + i
					break
			i += 1
		digit -= 1
	print("Part2: {A}")

fn load_machine(filename: str) -> Machine:
	var A = 0
	var B = 0
	var C = 0
	let code: Vector[int] = new_vector()
	var row_nr = 0

	for line in split_lines(text: read_file(filename)):
		line = trim(line)
		row_nr += 1
		switch row_nr:
			1:
				A = extract_number(line)
			2:
				B = extract_number(line)
			3:
				C = extract_number(line)
			5:
				for n in extract_numbers(line):
					code.append(n)
		else:
			pass
	Machine(A, B, C, pc: 0, code)

fn extract_number(line: str) -> int:
	match_to_int(option_unwrap(find(pattern: "[0-9]+", text: line)))

fn extract_numbers(line: str) -> List[int]:
	map(values: find_all(pattern: "[0-9]+", text: line), function: match_to_int)

fn match_to_int(m?: Match) -> int:
	str_to_int(m.text)

struct Machine:
	A: int
	B: int
	C: int
	pc: int
	code: Vector[int]
