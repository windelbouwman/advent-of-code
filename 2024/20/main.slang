
from std import print, read_file
from strlib import split_lines
from hashmap import HashMap, new_hashmap
from heapq import PriorityQueue, new_priority_queue_with_capacity
from math import abs
from vectype import Vector, new_vector

pub fn main() -> int:
    # solve(filename: "20/example.txt")
    solve(filename: "20/input.txt")
    0

fn solve(filename: str):
    let puzzle = load_puzzle(filename)

    # Shortest path
    let context = Context:
        queue: new_priority_queue_with_capacity(capacity: 10000, f: compare_position_and_cost)
        cost_map: new_hashmap(f_hash: position_hash, f_eq: position_equal)

    try_direction(context, row: puzzle.start.row, col: puzzle.start.col, new_cost: 0)
    while not context.queue.is_empty():
        let p = context.queue.pop()
        let cost = context.cost_map.get(key: p.pos)
        # print("Cost: {cost}")
        if position_equal(p.pos, puzzle.end):
            break

        if puzzle.grid.get(row: p.pos.row - 1, col: p.pos.col) == '.':
            try_direction(context, row: p.pos.row - 1, col: p.pos.col,  new_cost: cost + 1)
        if puzzle.grid.get(row: p.pos.row + 1, col: p.pos.col) == '.':
            try_direction(context, row: p.pos.row + 1, col: p.pos.col,  new_cost: cost + 1)
        if puzzle.grid.get(row: p.pos.row, col: p.pos.col - 1) == '.':
            try_direction(context, row: p.pos.row, col: p.pos.col - 1, new_cost: cost + 1)
        if puzzle.grid.get(row: p.pos.row, col: p.pos.col + 1) == '.':
            try_direction(context, row: p.pos.row, col: p.pos.col + 1, new_cost: cost + 1)

    let s1 = 0
    let s2 = 0
    for p1 in context.cost_map:
        for p2 in context.cost_map:
            let distance = manhattan_distance(p1, p2)
            let cost2 = context.cost_map.get(key: p2)
            let cost1 = context.cost_map.get(key: p1)
            let saved = (cost2 - cost1) - distance
            if distance == 2 and saved >= 100:
                s1 += 1
            if distance <= 20 and saved >= 100:
                s2 += 1
    print("[{filename}] Part 1: {s1}")
    print("[{filename}] Part 2: {s2}")

fn try_direction(context: Context, row: int, col: int, new_cost: int):
    let p1 = Position(row, col)
    let cheaper = if context.cost_map.contains(key: p1):
        new_cost < context.cost_map.get(key: p1)
    else:
        true

    if cheaper:
        context.queue.push(PositionAndCost(pos: p1, cost: new_cost))
        context.cost_map.insert(key: p1, value: new_cost)

struct Context:
    queue: PriorityQueue[PositionAndCost]
    cost_map: HashMap[Position, int]

fn compare_position_and_cost(a?: PositionAndCost, b?: PositionAndCost) -> bool:
    a.cost < b.cost

struct PositionAndCost:
    cost: int
    pos: Position

fn load_puzzle(filename: str) -> Puzzle:
    let rows: Vector[Vector[char]] = new_vector()
    let start = Position(row: 0, col: 0)
    let end = Position(row: 0, col: 0)

    let row_nr = 0
    for line in split_lines(text: read_file(filename)):
        let row: Vector[char] = new_vector()
        let col_nr = 0
        for c in line:
            if c == 'S':
                start.row = row_nr
                start.col = col_nr
                c = '.'
            elif c == 'E':
                end.row = row_nr
                end.col = col_nr
                c = '.'
            row.append(c)
            col_nr += 1
        rows.append(row)
        row_nr += 1

    let grid = Grid(rows)
    Puzzle(grid, start, end)

struct Puzzle:
    grid: Grid
    start: Position
    end: Position

class Grid:
    var rows: Vector[Vector[char]]

    fn width() -> int:
        rows[0].len()
    
    fn height() -> int:
        rows.len()

    pub fn get(row: int, col: int) -> char:
        rows[row][col]

    fn set(row: int, col: int, value: char):
        rows[row].set(index: col, value)

struct Position:
    row: int
    col: int

fn position_equal(a?: Position, b?: Position) -> bool:
    a.row == b.row and a.col == b.col

fn position_hash(a?: Position) -> int:
    a.row * 7919 + a.col

fn manhattan_distance(a?: Position, b?: Position) -> int:
    abs(a.row - b.row) + abs(a.col - b.col)
