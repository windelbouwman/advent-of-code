module main

from std import print, read_file
from base.strlib import split_lines, split_string
from base.listtype import List
from aoclib import get_numbers, contains

pub fn main():
	# let cards = load_data(filename: "example.txt")
	let cards = load_data(filename: "input.txt")
	part1(cards)
	part2(cards)

fn part1(cards: List[Card]):
	var sum = 0
	for card in cards:
		var points = 0
		for h in card.have:
			if contains(values: card.winning, value: h):
				if points > 0:
					points = points * 2
				else:
					points = 1
		sum += points
	print("Part 1: {sum}")  # 24733

fn part2(cards: List[Card]):
	var index = 0
	for card in cards:
		var count = 0
		for h in card.have:
			if contains(values: card.winning, value: h):
				count += 1
		index += 1

		var j = index
		while count > 0:
			cards.get(index: j).count += card.count
			j += 1
			count -= 1

	var sum = 0
	for card in cards:
		sum += card.count
	print("Part 2: {sum}")

fn load_data(filename: str) -> List[Card]:
	let cards: List[Card] = List()

	for line in split_lines(text: read_file(filename)):
		# Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
		let parts = split_string(text: line, sep: ':')
		let parts2 = split_string(text: parts.get(index: 1), sep: '|')
		let winning = get_numbers(text: parts2.get(index: 0), sep: ' ')
		let have = get_numbers(text: parts2.get(index: 1), sep: ' ')
		cards.append(Card(count: 1, winning, have))
	return cards

struct Card:
	# id: int
	count: int
	winning: List[int]
	have: List[int]
