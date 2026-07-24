module main

from std import print, read_file
from base.strlib import str_to_int
from base.functools import map, sum_integers
from base.regex import find_all_text

pub fn main() -> int:
	let text = read_file(filename: "03/input.txt")
	# let text = read_file(filename: "03/example.txt")
	# let text = read_file(filename: "03/example2.txt")
	part1(text)
	part2(text)
	0

fn part1(text: str):
	let s = sum_integers(values: map(values: find_all_text(pattern: "mul([0-9]+,[0-9]+)", text), function: calculate))
	print("Part1: {s}")

fn part2(text: str):
	var s = 0
	var enabled = true
	for op in find_all_text(pattern: "don't()|do()|mul([0-9]+,[0-9]+)", text):
		if op == "don't()":
			enabled = false
		elif op == "do()":
			enabled = true
		else:
			if enabled:
				s += calculate(text: op)
	print("Part2: {s}")

fn calculate(text: str) -> int:
	let numbers = map(values: find_all_text(pattern: "[0-9]+", text), function: str_to_int)
	numbers[0] * numbers[1]
