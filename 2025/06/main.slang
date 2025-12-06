from std import print, read_file, str_slice, str_len, ord, get_arg
from strlib import trim, split_string, str_to_int, split_lines, digit_to_int, is_digit
from math import modulo
from regex import split_at_pattern
from listtype import List
from vectype import Vector, new_vector
from utils import panic

type Worksheet = Vector[str]

pub fn main() -> int:
	let worksheet = read_worksheet(filename: get_arg(arg: 0))
	part1(worksheet)
	part2(worksheet)
	0

fn read_worksheet(filename: str) -> Worksheet:
	let text = read_file(filename)
	let worksheet: Vector[str] = new_vector()
	for line in split_lines(text):
		worksheet.append(line)
	worksheet

fn part1(worksheet: Worksheet):
	let rows: Vector[Vector[str]] = new_vector()
	for line in worksheet:
		let row: Vector[str] = new_vector()
		for part in split_at_pattern(text: trim(line), pattern: " +"):
			row.append(part)
		rows.append(row)

	let height = rows.len()
	let width = rows[0].len()
	var sum = 0
	var column = 0
	while column < width:
		var value = str_to_int(rows[0][column])
		let op = rows[height - 1][column]
		var row = 1
		while row < height - 1:
			let value2 = str_to_int(rows[row][column])
			if op == "+":
				value = value + value2
			elif op == "*":
				value = value * value2
			row += 1
		column += 1
		sum += value
	print("Part 1: {sum}")

fn part2(worksheet: Worksheet):
	var total = 0
	let n_rows = worksheet.len()
	var column = str_len(text: worksheet[0]) - 1
	let values: List[int] = List()
	while column >= 0:
		# Gather number:
		var value = 0
		var row = 0
		while row < n_rows - 1:
			let c = worksheet[row][column]
			if is_digit(c):
				value = value * 10 + digit_to_int(c)
			row += 1
		if value > 0:
			values.append(value)

		# Check operator:
		let op = worksheet[n_rows-1][column]
		if op == '*':
			total += calculate_product(values)
			values.clear()
		elif op == '+':
			total += calculate_sum(values)
			values.clear()
		elif op == ' ':
			pass
		else:
			panic("Weird op: {op}")
		column -= 1

	print("Part 2: {total}")

fn calculate_sum(values: List[int]) -> int:
	var res = 0
	for value in values:
		res += value
	res

fn calculate_product(values: List[int]) -> int:
	var res = 1
	for value in values:
		res = res * value
	res
