module main

from std import print, read_file
from base.utils import panic
from base.strlib import split_lines, split_string, trim, str_to_int
from base.listtype import List

pub fn main():
	let games = load_games()
	part1(games)
	part2(games)

fn part1(games: List[Game]):
	print("Part 1")

	var sum = 0
	for game in games:
		var is_possible = true
		for draw in game.draws:
			if draw.red > 12:
				is_possible = false
			if draw.green > 13:
				is_possible = false
			if draw.blue > 14:
				is_possible = false
			# only 12 red cubes, 13 green cubes, and 14 blue cube
		if is_possible:
			sum += game.id
	print("Sum of possible game id's: {sum}")  # 2683

fn part2(games: List[Game]):
	print("part 2")

	var sum = 0
	for game in games:
		let envelope = new_draw()
		for draw in game.draws:
			if envelope.red < draw.red:
				envelope.red = draw.red
			if envelope.green < draw.green:
				envelope.green = draw.green
			if envelope.blue < draw.blue:
				envelope.blue = draw.blue
		let power = envelope.red * envelope.green * envelope.blue
		sum += power
	print("Sum of powers: {sum}")


fn load_games() -> List[Game]:
	let games: List[Game] = List()

	for line in split_lines(text: read_file(filename: "input.txt")):
		# print(line)
		# Example line:
		# Game 4: 9 red, 3 green; 3 green, 8 red, 6 blue; 12 blue, 4 green, 6 red; 4 green, 18 blue, 11 red; 9 blue, 2 green, 3 red; 14 blue, 7 red

		let parts = split_string(text: line, sep: ':')
		let header: str = parts.first()
		let tail: str = parts.last()

		let game_id = str_to_int(split_string(text: header, sep: ' ').last())
		let draws: List[Draw] = List()
		# print("Game id: {game_id}")
		for draw_text in split_string(text: tail, sep: ';'):
			# print("Draw: {draw_text}")
			let draw = new_draw()
			for group_text in split_string(text: draw_text, sep: ','):
				# print(group_text)
				let parts3 = split_string(text: trim(group_text), sep: ' ')
				let count = str_to_int(parts3.first())
				let color = parts3.last()
				if color == "red":
					draw.red = count
				elif color == "blue":
					draw.blue = count
				elif color == "green":
					draw.green = count
				else:
					panic("Invalid color: {color}")
			draws.append(draw)

		let game = Game:
			id: game_id
			draws
		games.append(game)

	return games

struct Game:
	id: int
	draws: List[Draw]

fn new_draw() -> Draw:
	return Draw(red: 0, green: 0, blue: 0)

struct Draw:
	red: int
	green: int
	blue: int
