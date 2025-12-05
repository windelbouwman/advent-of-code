from std import print, read_file, str_slice, str_len
from strlib import trim, split_string, str_to_int
from math import modulo
from listtype import List
from utils import panic

pub fn main() -> int:
	let filename = "02/example.txt"
	# let filename = "02/input.txt"
	let ranges = read_ranges(filename)
	part1(ranges)
	part2(ranges)
	0

struct Range:
	lower: int
	upper: int

fn read_ranges(filename: str) -> List[Range]:
	let text = read_file(filename)
	let ranges: List[Range] = List()
	for pair in split_string(text: trim(text), sep: ','):
		let x = split_string(text: pair, sep: '-')
		let lower = str_to_int(x[0])
		let upper = str_to_int(x[1])
		ranges.append(Range(lower, upper))
	ranges

fn part1(ranges: List[Range]):
	let sum = sum_invalid_ids(ranges, invalidator: is_invalid_1)
	print("Part 1: {sum}")

fn part2(ranges: List[Range]):
	let sum = sum_invalid_ids(ranges, invalidator: is_invalid_2)
	print("Part 2: {sum}")

fn sum_invalid_ids(ranges: List[Range], invalidator: fn(int)->bool) -> int:
	var sum = 0
	var nr = 0
	for pair in ranges:
		var id = pair.lower
		while id <= pair.upper:
			if invalidator(id):
				sum += id
			id += 1
			nr += 1
	print("Checked {nr} id's")
	sum

fn is_invalid_1(id: int) -> bool:
	let text = str(id)
	let n = str_len(text)
	let x = n / 2
	let left = str_slice(text, begin: 0, end: x)
	let right = str_slice(text, begin: x, end: n)
	left == right

fn is_invalid_2(id: int) -> bool:
	let text = str(id)
	let n = str_len(text)

	var size = n / 2
	while size > 0:
		if modulo(value: n, divisor: size) == 0:
			let groups = split_in_groups(text, size)
			if all_equal(groups, reference: groups[0]):
				return true
		size -= 1
	false

fn split_in_groups(text: str, size: int) -> List[str]:
	let values = List()
	let n = str_len(text)
	var begin = 0
	while begin < n:
		let end = begin + size
		values.append(str_slice(text, begin, end))
		begin = end
	values

fn all_equal(groups: List[str], reference: str) -> bool:
	""" Check if all values in a list are the same """
	if groups.len() < 2:
		panic("Invalid")
	for value in groups:
		if value == reference:
			pass
		else:
			return false
	true
