
from std import str_len, str_slice
from strlib import split_string, trim, str_to_int
from listtype import List

pub fn get_numbers(text: str, sep: char) -> List[int]:
	let numbers: List[int] = List()
	for part in split_string(text, sep):
		part = trim(part)
		if is_empty(part):
			continue
		numbers.append(str_to_int(part))
	return numbers

fn is_empty(text?: str) -> bool:
	return str_len(text) == 0

struct Range:
	begin: int
	end: int

pub fn ranges_overlap(self: Range, other: Range) -> bool:
	return (self.begin <= other.end) and (other.begin <= self.end)

pub fn contains(values: List[int], value: int) -> bool:
	for v in values:
		if v == value:
			return true
	return false

pub fn find_min_value(values: List[int]) -> int:
	var x = values.get(index: 0)
	for value in values:
		if value < x:
			x = value
	return x



pub fn find_string(text: str, pattern: str) -> int:
	# Find a pattern in a text
	let n2 = str_len(text: pattern)
	let n = str_len(text) - n2 + 1
	var index = 0
	while index < n:
		let candidate = str_slice(text, begin: index, end: index + n2)
		if candidate == pattern:
			return index
		else:
			index += 1
	return -1

pub fn rfind_string(text: str, pattern: str) -> int:
	# Find a pattern in a text (from end of text)
	let n = str_len(text)
	let n2 = str_len(text: pattern)
	var index = n - n2
	while index >= 0:
		let candidate = str_slice(text, begin: index, end: index + n2)
		if candidate == pattern:
			return index
		else:
			index -= 1
	return -1


pub enum Direction:
	Up
	Down
	Left
	Right

pub fn turn_right(direction?: Direction) -> Direction:
	case direction:
		Up:
			Direction.Right()
		Down:
			Direction.Left()
		Left:
			Direction.Up()
		Right:
			Direction.Down()

pub fn dir_to_str(direction?: Direction) -> str:
	case direction:
		Up:
			"^"
		Down:
			"V"
		Left:
			"<"
		Right:
			">"

pub fn dir_eq(a?: Direction, b?: Direction) -> bool:
	dir_hash(a) == dir_hash(b)

pub fn dir_hash(d?: Direction) -> int:
	case d:
		Up:
			1
		Down:
			2
		Left:
			3
		Right:
			4
