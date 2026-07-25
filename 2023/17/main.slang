module main

from std import print, read_file
from base.vectype import Vector, new_vector
from base.heapq import PriorityQueue, new_priority_queue_with_capacity
from base.strlib import split_lines, digit_to_int
from base.hashmap import HashMap, new_hashmap

pub fn main() -> int:
	# let grid = load_grid(filename: "17/example.txt")
	# let grid = load_grid(filename: "17/example2.txt")
	let grid = load_grid(filename: "17/input.txt")
	part1(grid)
	0

fn part1(grid: Grid):
	let s1 = State(row: 4, col: 0, cost: grid.get(row: 1, col: 0) + grid.get(row: 2, col: 0) + grid.get(row: 3, col: 0) + grid.get(row: 4, col: 0), last: Direction.Down(), count: 4)
	let s2 = State(row: 0, col: 4, cost: grid.get(row: 0, col: 1) + grid.get(row: 0, col: 2) + grid.get(row: 0, col: 3) + grid.get(row: 0, col: 4), last: Direction.Right(), count: 4)
	let queue: PriorityQueue[State] = new_priority_queue_with_capacity(capacity: 10000, f: cmp_func)
	let cache: HashMap[State,int] = new_hashmap(f_hash: state_hash, f_eq: state_eq)
	let ctx = Context(grid, queue, cache, best: 0)
	push_state(ctx, s1)
	push_state(ctx, s2)
	while not queue.is_empty():
		let s = queue.pop()
		print("q = {queue.len()}")
		explore2(ctx, s)
	print("Part 2: {ctx.best}")

struct Context:
	grid: Grid
	queue: PriorityQueue[State]
	cache: HashMap[State,int]
	best: int

fn explore2(ctx: Context, s: State):
	let w = ctx.grid.get_width()
	let h = ctx.grid.get_height()

	case s.last:
		Up:
			# Try up:
			if s.row > 0 and s.count < 10:
				let cost = s.cost + ctx.grid.get(row: s.row - 1, col: s.col)
				let s1 = State(row: s.row - 1, col: s.col, cost, last: Direction.Up(), count: s.count + 1)
				push_state(ctx, s1)
			try_turn_left(ctx, s)
			try_turn_right(ctx, s)
		Down:
			# Try down:
			if s.row + 1 < h and s.count < 10:
				let cost = s.cost + ctx.grid.get(row: s.row + 1, col: s.col)
				let s1 = State(row: s.row + 1, col: s.col, cost, last: Direction.Down(), count: s.count + 1)
				push_state(ctx, s1)
			try_turn_left(ctx, s)
			try_turn_right(ctx, s)
		Left:
			# Try left:
			if s.col > 0 and s.count < 10:
				let cost = s.cost + ctx.grid.get(row: s.row, col: s.col - 1)
				let s1 = State(row: s.row, col: s.col - 1, cost, last: Direction.Left(), count: s.count + 1)
				push_state(ctx, s1)
			try_turn_up(ctx, s)
			try_turn_down(ctx, s)
		Right:
			# Try right:
			if s.col + 1 < w and s.count < 10:
				let cost = s.cost + ctx.grid.get(row: s.row, col: s.col + 1)
				let s1 = State(row: s.row, col: s.col + 1, cost, last: Direction.Right(), count: s.count + 1)
				push_state(ctx, s1)
			try_turn_up(ctx, s)
			try_turn_down(ctx, s)

fn try_turn_up(ctx: Context, s: State):
	if s.row > 3:
		let cost = s.cost + ctx.grid.get(row: s.row - 1, col: s.col) + ctx.grid.get(row: s.row - 2, col: s.col) + ctx.grid.get(row: s.row - 3, col: s.col) + ctx.grid.get(row: s.row - 4, col: s.col)
		let s1 = State(row: s.row - 4, col: s.col, cost, last: Direction.Up(), count: 4)
		push_state(ctx, s1)

fn try_turn_down(ctx: Context, s: State):
	let h = ctx.grid.get_height()
	if s.row + 4 < h:
		let cost = s.cost + ctx.grid.get(row: s.row + 1, col: s.col) + ctx.grid.get(row: s.row + 2, col: s.col) + ctx.grid.get(row: s.row + 3, col: s.col) + ctx.grid.get(row: s.row + 4, col: s.col)
		let s1 = State(row: s.row + 4, col: s.col, cost, last: Direction.Down(), count: 4)
		push_state(ctx, s1)

fn try_turn_left(ctx: Context, s: State):
	if s.col > 3:
		let cost = s.cost + ctx.grid.get(row: s.row, col: s.col - 1) + ctx.grid.get(row: s.row, col: s.col - 2) + ctx.grid.get(row: s.row, col: s.col - 3) + ctx.grid.get(row: s.row, col: s.col - 4)
		let s1 = State(row: s.row, col: s.col - 4, cost, last: Direction.Left(), count: 4)
		push_state(ctx, s1)

fn try_turn_right(ctx: Context, s: State):
	let w = ctx.grid.get_width()
	if s.col + 4 < w:
		let cost = s.cost + ctx.grid.get(row: s.row, col: s.col + 1) + ctx.grid.get(row: s.row, col: s.col + 2) + ctx.grid.get(row: s.row, col: s.col + 3) + ctx.grid.get(row: s.row, col: s.col + 4)
		let s1 = State(row: s.row, col: s.col + 4, cost, last: Direction.Right(), count: 4)
		push_state(ctx, s1)

fn push_state(ctx: Context, s?: State):
	# let key = "{s.row},{s.col},{direction_to_string(s.last)},{s.count}"
	# print("{key} => {s.cost}")
	let is_cheapest = if ctx.cache.contains(key: s):
		# print("Better way -> {key}")
		s.cost < ctx.cache.get(key: s)
	else:
		true

	if is_cheapest:
		ctx.cache.insert(key: s, value: s.cost)
		ctx.queue.push(s)

	# Keep track of best option to reach bottom right
	let w = ctx.grid.get_width()
	let h = ctx.grid.get_height()
	if s.row == h - 1 and s.col == w - 1:
		if ctx.best == 0 or (ctx.best > 0 and s.cost < ctx.best):
			ctx.best = s.cost
			# print("{key} -> {s.cost}")
	pass

struct State:
	row: int
	col: int
	cost: int
	last: Direction
	count: int

fn cmp_func(a?: State, b?: State) -> bool:
	a.cost < b.cost

fn state_hash(s?: State) -> uint32:
	uint32(s.row * 719 + s.col * 139 + direction_hash(s.last) * 71 + s.count)

fn state_eq(a?: State, b?: State) -> bool:
	(a.row == b.row) and (a.col == b.col) and direction_eq(a.last, b.last) and (a.count == b.count)

enum Direction:
	Up
	Down
	Left
	Right

fn direction_hash(d?: Direction) -> int:
	case d:
		Up:
			1
		Down:
			2
		Left:
			3
		Right:
			4

fn direction_eq(a?: Direction, b?: Direction) -> bool:
	case a:
		Up:
			case b:
				Up:
					true
			else:
				false
		Down:
			case b:
				Down:
					true
			else:
				false
		Left:
			case b:
				Left:
					true
			else:
				false
		Right:
			case b:
				Right:
					true
			else:
				false

fn direction_to_string(direction?: Direction) -> str:
	case direction:
		Up:
			"U"
		Down:
			"D"
		Left:
			"L"
		Right:
			"R"

fn load_grid(filename: str) -> Grid:
	let rows: Vector[Vector[int]] = new_vector()
	let lines = split_lines(text: read_file(filename))
	for line in lines:
		let row: Vector[int] = new_vector()
		for c in line:
			row.append(digit_to_int(c))
		rows.append(row)
	Grid(rows)

class Grid:
	var rows: Vector[Vector[int]]

	pub fn get_width() -> int:
		rows[0].len()

	pub fn get_height() -> int:
		rows.len()

	pub fn get(row: int, col: int) -> int:
		rows[row][col]
