
from std import print, read_file
from strlib import split_lines
from vectype import Vector, new_vector
from settype import Set, new_set
from datatypes import List

pub fn main() -> int:
    # let grid = load_grid(filename: "12/example1.txt")
    # let grid = load_grid(filename: "12/example2.txt")
    # let grid = load_grid(filename: "12/example3.txt")
    # let grid = load_grid(filename: "12/example4.txt")
    let grid = load_grid(filename: "12/input.txt")
    part1(grid)
    part2(grid)
    0

fn part1(grid: Grid):
    let w = grid.width()
    let h = grid.height()
    let s = 0
    let visited: Set[Position] = new_set(f_hash: position_hash, f_eq: position_equal)
    let row = 0
    while row < h:
        let col = 0
        while col < w:
            let p0 = Position(row, col)
            if not visited.contains(key: p0):
                s += find_area(grid, visited, p0)
            col += 1
        row += 1
    print("Part1: {s}")

fn find_area(grid: Grid, visited: Set[Position], p0: Position) -> int:
    """ Perform a flood fill operation. """
    let w = grid.width()
    let h = grid.height()
    # let area: Set[Position] = new_set(f_hash: position_hash, f_eq: position_equal)
    let work: List[Position] = List()
    let area = 0
    let perimeter = 0
    let c = grid.get(p0)
    visited.add(p0)
    work.append(p0)
    while not work.is_empty():
        let p = work.pop_front()
        area += 1
        for neighbour in neighbours(p):
            if neighbour.row < 0 or neighbour.col < 0 or neighbour.row >= h or neighbour.col >= w:
                perimeter += 1
                continue
            let c2 = grid.get(neighbour)
            if c2 == c:
                if not visited.contains(key: neighbour):
                    visited.add(neighbour)
                    work.append(neighbour)
            else:
                perimeter += 1
    area * perimeter

fn part2(grid: Grid):
    let w = grid.width()
    let h = grid.height()
    let s = 0
    let visited: Set[Position] = new_set(f_hash: position_hash, f_eq: position_equal)
    let row = 0
    while row < h:
        let col = 0
        while col < w:
            let p0 = Position(row, col)
            if not visited.contains(key: p0):
                s += find_area2(grid, visited, p0)
            col += 1
        row += 1
    print("Part2: {s}")

fn find_area2(grid: Grid, visited: Set[Position], p0: Position) -> int:
    """ Perform a flood fill operation, then detect corners. """
    let w = grid.width()
    let h = grid.height()
    let area: Set[Position] = new_set(f_hash: position_hash, f_eq: position_equal)
    let work: List[Position] = List()
    let c = grid.get(p0)
    visited.add(p0)
    work.append(p0)
    while not work.is_empty():
        let p = work.pop_front()
        area.add(p)
        for neighbour in neighbours(p):
            if neighbour.row < 0 or neighbour.col < 0 or neighbour.row >= h or neighbour.col >= w:
                continue
            let c2 = grid.get(neighbour)
            if c2 == c:
                if not visited.contains(key: neighbour):
                    visited.add(neighbour)
                    work.append(neighbour)

    # Detect corners:
    let corners = 0
    for x in area:
        # Outer corners:
        if (not area.contains(Position(row: x.row - 1, col: x.col))) and (not area.contains(Position(row: x.row, col: x.col + 1))):
            corners += 1
        if (not area.contains(Position(row: x.row + 1, col: x.col))) and (not area.contains(Position(row: x.row, col: x.col + 1))):
            corners += 1
        if (not area.contains(Position(row: x.row - 1, col: x.col))) and (not area.contains(Position(row: x.row, col: x.col - 1))):
            corners += 1
        if (not area.contains(Position(row: x.row + 1, col: x.col))) and (not area.contains(Position(row: x.row, col: x.col - 1))):
            corners += 1
        # Inner corners:
        if (area.contains(Position(row: x.row + 1, col: x.col))) and (area.contains(Position(row: x.row, col: x.col + 1))) and not (area.contains(Position(row: x.row + 1, col: x.col + 1))):
            corners += 1
        if (area.contains(Position(row: x.row + 1, col: x.col))) and (area.contains(Position(row: x.row, col: x.col - 1))) and not (area.contains(Position(row: x.row + 1, col: x.col - 1))):
            corners += 1
        if (area.contains(Position(row: x.row - 1, col: x.col))) and (area.contains(Position(row: x.row, col: x.col + 1))) and not (area.contains(Position(row: x.row - 1, col: x.col + 1))):
            corners += 1
        if (area.contains(Position(row: x.row - 1, col: x.col))) and (area.contains(Position(row: x.row, col: x.col - 1))) and not (area.contains(Position(row: x.row - 1, col: x.col - 1))):
            corners += 1

    area.len() * corners

fn load_grid(filename: str) -> Grid:
    let rows: Vector[Vector[char]] = new_vector()
    let lines = split_lines(text: read_file(filename))
    for line in lines:
        let row: Vector[char] = new_vector()
        for c in line:
            row.append(c)
        rows.append(row)

    Grid(rows)

fn neighbours(position?: Position) -> List[Position]:
    let x: List[Position] = List()
    x.append(Position(row: position.row, col: position.col + 1))
    x.append(Position(row: position.row, col: position.col - 1))
    x.append(Position(row: position.row + 1, col: position.col))
    x.append(Position(row: position.row - 1, col: position.col))
    x

struct Position:
    row: int
    col: int

fn position_equal(a?: Position, b?: Position) -> bool:
    a.row == b.row and a.col == b.col

fn position_hash(a?: Position) -> int:
    a.row * 7919 + a.col

class Grid:
    var rows: Vector[Vector[char]]

    pub fn width() -> int:
        rows[0].len()
    
    pub fn height() -> int:
        rows.len()

    pub fn get(p?: Position) -> char:
        rows[p.row][p.col]
