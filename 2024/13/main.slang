module main

from std import print, read_file
from base.strlib import split_lines, str_to_int
from base.regex import find_all, Match
from base.functools import map
from base.listtype import List

pub fn main() -> int:
	# let machines = load_machines(filename: "13/example.txt")
	let machines = load_machines(filename: "13/input.txt")
	part_n(machines, part: 1)
	part_n(machines, part: 2)
	0

fn part_n(machines: List[Machine], part: int):
	let offset = if part == 2:
		10000000000000
	else:
		0
	var s = 0
	for machine in machines:
		# print("machine: {machine.ax}, {machine.ay}")
		machine.px += offset
		machine.py += offset
		# See: https://www.youtube.com/watch?v=-5J-DAsWuJc
		let ca_num = machine.px * machine.by - machine.py * machine.bx
		let ca_den = machine.ax * machine.by - machine.ay * machine.bx
		let ca: int = ca_num / ca_den
		let cb_num = machine.px - machine.ax * ca
		let cb: int = cb_num / machine.bx
		if (ca * ca_den == ca_num) and (cb * machine.bx == cb_num):
			s += ca * 3 + cb
	print("Part{part}: {s}")

fn parse_numbers(line: str) -> List[int]:
	map(values: find_all(pattern: "[0-9]+", text: line), function: match_to_int)

fn match_to_int(m: Match) -> int:
	str_to_int(m.text)

fn load_machines(filename: str) -> List[Machine]:
	let lines = split_lines(text: read_file(filename))
	let machines: List[Machine] = List()
	var section = 0
	var ax = 0
	var ay = 0
	var bx = 0
	var by = 0
	var px = 0
	var py = 0
	for line in lines:
		if section == 0:
			let numbers = parse_numbers(line)
			ax = numbers[0]
			ay = numbers[1]
			section = 1
		elif section == 1:
			let numbers = parse_numbers(line)
			bx = numbers[0]
			by = numbers[1]
			section = 2
		elif section == 2:
			let numbers = parse_numbers(line)
			px = numbers[0]
			py = numbers[1]
			machines.append(Machine(ax, ay, bx, by, py, px))
			section = 3
		elif section == 3:
			section = 0

	machines

struct Machine:
	ax: int
	ay: int
	bx: int
	by: int
	px: int
	py: int
