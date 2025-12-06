
from std import print, read_file
from strlib import split_lines
from datatypes import List
from hashmap import HashMap, new_hashmap
from heapq import PriorityQueue, new_priority_queue_with_capacity
from vectype import Vector, new_vector
from settype import Set, new_set, new_str_set


pub fn main() -> int:
    solve(filename: "16/example.txt")
    solve(filename: "16/example2.txt")
    solve(filename: "16/input.txt")
    0

fn solve(filename: str):
    let puzzle = load_puzzle(filename)
    let queue: PriorityQueue[PositionAndCost] = new_priority_queue_with_capacity(capacity: 10000, f: compare_position_and_cost)
    let came_from: HashMap[Position, List[Position]] = new_hashmap(f_hash: position_hash, f_eq: position_equal)
    let cost_map: HashMap[Position, int] = new_hashmap(f_hash: position_hash, f_eq: position_equal)
    try_direction(cost_map, queue, came_from, p: puzzle.start, row: puzzle.start.row, col: puzzle.start.col, dir: puzzle.start.dir, new_cost: 0)
    let end = puzzle.end
    while not queue.is_empty():
        let p = queue.pop()
        let cost = cost_map.get(key: p.pos)
        # print("Cost: {cost}")
        if p.pos.row == puzzle.end.row and p.pos.col == puzzle.end.col:
            print("Part1: {cost}")
            end = p.pos
            break
        case p.pos.dir:
            North:
                if puzzle.grid.get(row: p.pos.row - 1, col: p.pos.col) == '.':
                    try_direction(cost_map, queue, came_from, p: p.pos, row: p.pos.row - 1, col: p.pos.col, dir: Direction.North(), new_cost: cost + 1)
                try_direction(cost_map, queue, came_from, p: p.pos, row: p.pos.row, col: p.pos.col, dir: Direction.West(), new_cost: cost + 1000)
                try_direction(cost_map, queue, came_from, p: p.pos, row: p.pos.row, col: p.pos.col, dir: Direction.East(), new_cost: cost + 1000)
            South:
                if puzzle.grid.get(row: p.pos.row + 1, col: p.pos.col) == '.':
                    try_direction(cost_map, queue, came_from, p: p.pos, row: p.pos.row + 1, col: p.pos.col, dir: Direction.South(), new_cost: cost + 1)
                try_direction(cost_map, queue, came_from, p: p.pos, row: p.pos.row, col: p.pos.col, dir: Direction.West(), new_cost: cost + 1000)
                try_direction(cost_map, queue, came_from, p: p.pos, row: p.pos.row, col: p.pos.col, dir: Direction.East(), new_cost: cost + 1000)
            West:
                if puzzle.grid.get(row: p.pos.row, col: p.pos.col - 1) == '.':
                    try_direction(cost_map, queue, came_from, p: p.pos, row: p.pos.row, col: p.pos.col - 1, dir: Direction.West(), new_cost: cost + 1)
                try_direction(cost_map, queue, came_from, p: p.pos, row: p.pos.row, col: p.pos.col, dir: Direction.North(), new_cost: cost + 1000)
                try_direction(cost_map, queue, came_from, p: p.pos, row: p.pos.row, col: p.pos.col, dir: Direction.South(), new_cost: cost + 1000)
            East:
                if puzzle.grid.get(row: p.pos.row, col: p.pos.col + 1) == '.':
                    try_direction(cost_map, queue, came_from, p: p.pos, row: p.pos.row, col: p.pos.col + 1, dir: Direction.East(), new_cost: cost + 1)
                try_direction(cost_map, queue, came_from, p: p.pos, row: p.pos.row, col: p.pos.col, dir: Direction.North(), new_cost: cost + 1000)
                try_direction(cost_map, queue, came_from, p: p.pos, row: p.pos.row, col: p.pos.col, dir: Direction.South(), new_cost: cost + 1000)

    # Back track the paths leading to the end
    let visited: Set[Position] = new_set(f_hash: position_hash, f_eq: position_equal)
    let spots: Set[str] = new_str_set()
    let q2: List[Position] = List()
    q2.append(end)
    while not q2.is_empty():
        let p = q2.pop_front()
        spots.add("{p.row},{p.col}")
        if not visited.contains(key: p):
            visited.add(p)
            for pred in came_from.get(key: p):
                q2.append(pred)

    print("Part2: {spots.len()}")

fn try_direction(cost_map: HashMap[Position, int], queue: PriorityQueue[PositionAndCost], came_from: HashMap[Position, List[Position]], p: Position, row: int, col: int, dir: Direction, new_cost: int):
    let p1 = Position(row, col, dir)
    let cheaper = if cost_map.contains(key: p1):
        new_cost < cost_map.get(key: p1)
    else:
        true

    if cheaper:
        queue.push(PositionAndCost(pos: p1, cost: new_cost))
        cost_map.insert(key: p1, value: new_cost)

    let cheaper_or_equal = if cost_map.contains(key: p1):
        new_cost <= cost_map.get(key: p1)
    else:
        true

    if cheaper_or_equal:
        let pred_list = if came_from.contains(key: p1):
            came_from.get(key: p1)
        else:
            let pred_list: List[Position] = List()
            came_from.insert(key: p1, value: pred_list)
            pred_list
        pred_list.append(p)

fn load_puzzle(filename: str) -> Puzzle:
    let rows: Vector[Vector[char]] = new_vector()
    let start = Position(row: 0, col: 0, dir: Direction.East())
    let end = Position(row: 0, col: 0, dir: Direction.East())

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

fn compare_position_and_cost(a?: PositionAndCost, b?: PositionAndCost) -> bool:
    a.cost < b.cost

struct PositionAndCost:
    cost: int
    pos: Position

struct Position:
    row: int
    col: int
    dir: Direction

fn position_equal(a?: Position, b?: Position) -> bool:
    a.row == b.row and a.col == b.col and direction_equal(a.dir, b.dir)

fn position_hash(a?: Position) -> int:
    a.row * 7919 + a.col + direction_hash(a.dir) * 73

enum Direction:
    North
    East
    South
    West

fn direction_equal(a?: Direction, b?: Direction) -> bool:
    direction_hash(a) == direction_hash(b)

fn direction_hash(a?: Direction) -> int:
    case a:
        North:
            0
        East:
            1
        South:
            2
        West:
            3

class Grid:
    var rows: Vector[Vector[char]]

    fn width() -> int:
        rows[0].len()
    
    fn height() -> int:
        rows.len()

    pub fn get(row: int, col: int) -> char:
        rows[row][col]
