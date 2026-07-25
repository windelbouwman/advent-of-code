module main

from std import print, read_file
from base.math import abs
from base.strlib import str_to_int, split_string, split_lines
from base.functools import map, all
from base.listtype import List

pub fn main() -> int:
	let reports = load_puzzle(filename: "02/input.txt")
	# let reports = load_puzzle(filename: "02/example.txt")
	part1(reports)
	part2(reports)
	0

fn load_puzzle(filename: str) -> List[List[int]]:
	let reports: List[List[int]] = List()
	for line in split_lines(text: read_file(filename)):
		let levels = map(values: split_string(text: line, sep: ' '), function: str_to_int)
		reports.append(levels)
	reports

fn part1(reports: List[List[int]]):
	var s = 0
	for report in reports:
		if is_safe(report):
			s += 1
	print("Part1: {s}")

fn is_safe(report: List[int]) -> bool:
	let values = diff(report)
	if all(values, check: is_between_1_and_3):
		all(values, check: is_positive) or all(values, check: is_negative)
	else:
		false

fn is_positive(value?: int) -> bool:
	value > 0

fn is_negative(value?: int) -> bool:
	value < 0

fn is_between_1_and_3(value?: int) -> bool:
	value = abs(value)
	value >= 1 and value <= 3

fn diff(values?: List[int]) -> List[int]:
	var index = 1
	let res: List[int] = List()
	while index < values.len():
		res.append(values[index]-values[index - 1])
		index += 1
	res

fn part2(reports: List[List[int]]):
	var s = 0
	for report in reports:
		for mutation in create_mutations(report):
			if is_safe(report: mutation):
				s += 1
				break
	print("Part 2: {s}")

fn create_mutations(report: List[int]) -> List[List[int]]:
	let mutations: List[List[int]] = List()
	var index = 0
	while index < report.len():
		let mutation: List[int] = List()
		var index2 = 0
		while index2 < report.len():
			if index != index2:
				mutation.append(report[index2])
			index2 += 1
		mutations.append(mutation)
		index += 1
	mutations
