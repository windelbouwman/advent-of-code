module main

from std import read_file, print
from base.strlib import split_lines, split_string, str_to_int
from base.listtype import List
from base.hashmap import HashMap, new_hashmap_str
from base.sorting import sort_list
from base.utils import panic, assert

pub fn main() -> int:
	# let puzzle = load_data("example.txt")
	let puzzle = load_data(filename: "input.txt")
	# let puzzle = load_data(filename: "example.txt")
	part1(puzzle)
	0

fn load_data(filename: str) -> Puzzle:
	let cards = 1
	let hands: List[Hand] = List()
	for line in split_lines(text: read_file(filename)):
		let parts = split_string(text: line, sep: ' ')
		let text = parts.first()
		let bid = str_to_int(parts.last())
		print("cards={text} bid={bid}")
		let cards: List[int] = List()
		for c in text:
			let x = card_value(c)
			print("card value={x}")
			cards.append(x)

		let typ = get_type(cards)
		print("Typ: {typ}")
		let hand = Hand(text, cards, typ, bid)
		hands.append(hand)
	return Puzzle(hands)

fn get_type(cards: List[int]) -> int:
	# 7 = five of a kind
	# 6 = four of a kind
	# 5 = full house
	# 4 = three of a kind
	# 3 = two pair
	# 2 = one pair
	# 1 = high card

	# Part two: remove jokers
	var n_jokers = 0
	let new_cards = List()
	for c in cards:
		if c == 1:
			n_jokers += 1
		else:
			new_cards.append(c)
	let same = count_same(values: new_cards)
	if n_jokers == 5:
		assert(condition: same.is_empty(), message: "expect same to be empty")
		same.append(5)
	else:
		let index = same.len() - 1
		while n_jokers > 0:
			n_jokers -= 1
			same.set(index, value: same.get(index) + 1)
	for v in same:
		print("cnt = {v}")

	if same.len() == 5:
		# Must be 1,1,1,1,1
		return 1  # high card
	elif same.len() == 4:
		# Must be 1,1,1,2
		return 2  # one pair
	elif same.len() == 3:
		# 1,1,3 or 1,2,2
		if same.get(index: 2) == 3:
			return 4  # three of a kind
		else:
			return 3  # two pair
	elif same.len() == 2:
		# 2,3 or 1,4
		if same.get(index: 1) == 4:
			return 6
		else:
			return 5
	else:
		return 7

fn count_same(values: List[int]) -> List[int]:
	# Count same values
	let d: HashMap[str,int] = new_hashmap_str()

	for value in values:
		let key = "{value}"
		if d.contains(key):
			d.insert(key, value: d.get(key) + 1)
		else:
			d.insert(key, value: 1)

	let counts: List[int] = List()
	for key in d:
		counts.append(d.get(key))
	return sort_list(counts, cmp: compare_integers)

fn compare_integers(a: int, b: int) -> bool:
	return a < b

fn compare_hands(a: Hand, b: Hand) -> bool:
	if a.typ == b.typ:
		# return string_compare(a: a.text, b: b.text)
		var index = 0
		while index < 5:
			let a_i = a.cards.get(index)
			let b_i = b.cards.get(index)
			if a_i == b_i:
				index += 1
			else:
				return a_i < b_i
		panic("Out of cards!")
	else:
		return a.typ < b.typ

fn part1(puzzle: Puzzle):
	print("Part 1")
	let s2: List[Hand] = sort_list(puzzle.hands, cmp: compare_hands)
	var score = 0
	var rank = 1
	for h in s2:
		print("hand = {h.text} bid = {h.bid}")
		score += rank * h.bid
		rank += 1
	print("Part 1: {score}")

fn card_value(c: char) -> int:
	if c == '2':
		return 2
	elif c == '3':
		return 3
	elif c == '4':
		return 4
	elif c == '5':
		return 5
	elif c == '6':
		return 6
	elif c == '7':
		return 7
	elif c == '8':
		return 8
	elif c == '9':
		return 9
	elif c == 'T':
		return 10
	elif c == 'J':
		# return 11
		return 1
	elif c == 'Q':
		return 12
	elif c == 'K':
		return 13
	elif c == 'A':
		return 14
	else:
		panic("Unsupported char: {c}")

struct Puzzle:
	hands: List[Hand]

struct Hand:
	text: str
	cards: List[int]
	typ: int
	bid: int
