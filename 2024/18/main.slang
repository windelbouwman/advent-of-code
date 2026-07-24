module main

from std import print, read_file
from base.strlib import split_lines, split_string, str_to_int
from base.listtype import List
from base.optiontype import Option
from base.hashmap import HashMap, new_hashmap
from base.heapq import PriorityQueue, new_priority_queue_with_capacity
from base.settype import Set, new_set

pub fn main() -> int:
	# solve(filename: "18/example.txt", N: 7)
	solve(filename: "18/input.txt", N: 71)
	0

fn solve(filename: str, N: int):
	let pairs = load_pairs(filename)

	case find_path_after(pairs, N, limit: 1024):
		Some(x):
			print("Part 1: {x}")
		None:
			print("Invalid part 1")

	# Bisect part 2:
	var high = pairs.len()
	var low = 0
	while low + 1 < high:
		let limit = (high + low) / 2
		case find_path_after(pairs, N, limit):
			Some(x):
				low = limit
			None:
				high = limit
	print("Part 2 {position_to_string(pairs[low])}")

fn find_path_after(pairs: List[Position], N: int, limit: int) -> Option[int]:
	let grid = fill_grid(pairs, limit)
	find_path(grid, N)

fn fill_grid(pairs: List[Position], limit: int) -> Set[Position]:
	var cnt = 0
	let grid: Set[Position] = new_set(f_hash: position_hash, f_eq: position_equal)
	for position in pairs:
		grid.add(position)
		cnt += 1
		if cnt >= limit:
			break
	grid

fn find_path(grid: Set[Position], N: int) -> Option[int]:
	let start = Position(x: 0, y: 0)
	let end = Position(x: N - 1, y: N - 1)

	# A*-ish algorithm:
	let ctx = Ctx:
		grid
		N
		queue: new_priority_queue_with_capacity(capacity: 10000, f: compare_position_and_cost)
		cost_map: new_hashmap(f_hash: position_hash, f_eq: position_equal)
	try_direction(ctx, p: start, dx: 0, dy: 0, new_cost: 0)

	while not ctx.queue.is_empty():
		let p = ctx.queue.pop()
		let cost = ctx.cost_map.get(key: p.pos)
		if position_equal(p.pos, end):
			return Option.Some(cost)
		try_direction(ctx, p: p.pos, dx: 1, dy: 0, new_cost: cost + 1)
		try_direction(ctx, p: p.pos, dx: -1, dy: 0, new_cost: cost + 1)
		try_direction(ctx, p: p.pos, dx: 0, dy: 1, new_cost: cost + 1)
		try_direction(ctx, p: p.pos, dx: 0, dy: -1, new_cost: cost + 1)
	Option.None()

struct Ctx:
	grid: Set[Position]
	N: int
	queue: PriorityQueue[PositionAndCost]
	cost_map: HashMap[Position, int]

fn try_direction(ctx: Ctx, p: Position, dx: int, dy: int, new_cost: int):
	let x = p.x + dx
	let y = p.y + dy
	if x < 0 or y < 0 or x >= ctx.N or y >= ctx.N:
		return
	let p1 = Position(x, y)
	if ctx.grid.contains(p1):
		return

	let is_cheaper = if ctx.cost_map.contains(key: p1):
		new_cost < ctx.cost_map.get(key: p1)
	else:
		true

	if is_cheaper:
		ctx.queue.push(PositionAndCost(pos: p1, cost: new_cost))
		ctx.cost_map.insert(key: p1, value: new_cost)

fn load_pairs(filename: str) -> List[Position]:
	let pairs: List[Position] = List()
	for line in split_lines(text: read_file(filename)):
		let parts = split_string(text: line, sep: ',')
		let x = str_to_int(parts[0])
		let y = str_to_int(parts[1])
		pairs.append(Position(x, y))
	pairs

fn compare_position_and_cost(a?: PositionAndCost, b?: PositionAndCost) -> bool:
	a.cost < b.cost

struct PositionAndCost:
	cost: int
	pos: Position

struct Position:
	x: int
	y: int

fn position_equal(a?: Position, b?: Position) -> bool:
	a.x == b.x and a.y == b.y

fn position_hash(a?: Position) -> uint32:
	uint32(a.x * 7919 + a.y)

fn position_to_string(a?: Position) -> str:
	"{a.x},{a.y}"
