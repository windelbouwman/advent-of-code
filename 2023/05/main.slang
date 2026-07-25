module main

from std import read_file, print, str_len
from base.strlib import split_lines, split_string
from base.utils import assert
from base.listtype import List
from aoclib import get_numbers, find_min_value
from base.sorting import sort_list

pub fn main():
	# let puzzle = load_data(filename: "example.txt")
	let puzzle = load_data(filename: "input.txt")
	part1(puzzle)
	part2(puzzle)

fn load_data(filename: str) -> Puzzle:
	var state = 0
	var seeds = List()
	var mapname = ""
	var rangemaps: List[IntervalMap] = List()
	let mappings: List[Mapping] = List()
	for line in split_lines(text: read_file(filename)):
		switch state:
			0:
				print("Seed: {line}")
				seeds = get_numbers(text: split_string(text: line, sep: ':').get(index: 1), sep: ' ')
				state = 1
			1:
				state = 2
			2:
				mapname = line
				rangemaps = List()
				state = 3
			3:
				if str_len(text: line) == 0:
					state = 2
					mappings.append(new_mapping(name: mapname, rangemaps))
				else:
					let numbers = get_numbers(text: line, sep: ' ')
					rangemaps.append(IntervalMap(destination: numbers.get(index: 0), source: numbers.get(index: 1), length: numbers.get(index: 2)))
		else:
			pass

	if state == 3:
		mappings.append(new_mapping(name: mapname, rangemaps))

	return Puzzle(seeds, mappings)

fn part1(puzzle: Puzzle):
	let locations: List[int] = List()
	for seed in puzzle.seeds:
		print("seed: {seed}")
		for mapping in puzzle.mappings:
			seed = map_value(value: seed, mapping)
			print("    {mapping.name} -> {seed}")
		locations.append(seed)

	let smallest_location = find_min_value(values: locations)
	print("part 1: {smallest_location}")

fn part2(puzzle: Puzzle):
	# Idea: run ranges through mappings
	var ranges = seeds_to_ranges(seeds: puzzle.seeds)

	for mapping in puzzle.mappings:
		print("    {mapping.name}")
		ranges = map_ranges(ranges, mapping)
		# for range in ranges:
	let values: List[int] = List()
	for range in ranges:
		print("  -> [{range.begin},{range.end})")
		values.append(range.begin)
	let smallest_location = find_min_value(values)
	print("Part 2: {smallest_location}")

fn seeds_to_ranges(seeds: List[int]) -> List[Range]:
	let ranges: List[Range] = List()
	var first = true
	var begin = 0
	var end = 0
	for seed in seeds:
		if first:
			first = false
			begin = seed
		else:
			first = true
			end = begin + seed
			ranges.append(Range(begin, end))
	return ranges

fn map_ranges(ranges: List[Range], mapping: Mapping) -> List[Range]:
	let new_ranges: List[Range] = List()
	for range in ranges:
		for new_range in map_range(range, mapping):
			new_ranges.append(new_range)
	return new_ranges

fn map_range(range: Range, mapping: Mapping) -> List[Range]:
	let new_ranges: List[Range] = List()
	var x = range.begin
	# Assume here the rangemaps are sorted on source value
	for interval in mapping.rangemaps:
		let begin = min(interval.source, range.end)

		if x < begin:  # We have some range before the interval
			# Add a none mapped range:
			new_ranges.append(Range(begin: x, end: begin))
			x = begin

		let end = min(interval.source + interval.length, range.end)
		let offset = interval.destination - interval.source
		if x < end:  # We have some range in the interval
			new_ranges.append(Range(begin: x + offset, end: end + offset))
			x = end

	if x < range.end:
		new_ranges.append(Range(begin: x, end: range.end))

	return new_ranges

fn min(a?: int, b?: int) -> int:
	if a < b:
		return a
	else:
		return b

struct Range:
	begin: int  # Inclusive
	end: int  # Exclusive

struct Puzzle:
	seeds: List[int]
	mappings: List[Mapping]

struct IntervalMap:
	destination: int
	source: int
	length: int

fn compare_interval_maps(a: IntervalMap, b: IntervalMap) -> bool:
	return a.source < b.source

fn new_mapping(name: str, rangemaps: List[IntervalMap]) -> Mapping:
	rangemaps = sort_list(rangemaps, cmp: compare_interval_maps)
	print("Map: {name}")
	var end = -1
	for interval in rangemaps:
		assert(condition: end < interval.source, message: "Only support non overlapping ranges")
		print(" {interval.destination} < {interval.source} len={interval.length}")
		end = interval.source + interval.length - 1
	return Mapping(name, rangemaps)

struct Mapping:
	name: str
	rangemaps: List[IntervalMap]

fn map_value(value: int, mapping: Mapping) -> int:
	for range in mapping.rangemaps:
		if range.source <= value and value < range.source + range.length:
			let offset = value - range.source
			return range.destination + offset
	return value
