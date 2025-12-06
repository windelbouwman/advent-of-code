
from std import print, read_file
from strlib import split_lines, digit_to_int
from vectype import Vector, new_vector
from settype import Set, new_set
from datatypes import List

pub fn main() -> int:
    let grid = load_grid(filename: "10/input.txt")
    # let grid = load_grid(filename: "10/example2.txt")
    part1(grid)
    part2(grid)
    0

fn part1(grid: Grid):
    let w = grid.width()
    let h = grid.height()
    let s = 0
    let row = 0
    while row < h:
        let col = 0
        while col < w:
            if grid.get(row, col) == 0:
                s += find_hikes(grid, row, col)
            col += 1
        row += 1
    print("Part1: {s}")

fn find_hikes(grid: Grid, row: int, col: int) -> int:
    let w = grid.width()
    let h = grid.height()
    let nr = 0
    let backlog: List[State] = List()
    let visited: Set[State] = new_set(f_hash: state_hash, f_eq: state_eq)
    let s0 = State(row, col)
    backlog.append(s0)
    visited.add(s0)
    while not backlog.is_empty():
        let s = backlog.pop_front()
        let x = grid.get(row: s.row, col: s.col)
        if x == 9:
            nr += 1
        else:
            x += 1
            if s.row > 0 and grid.get(row: s.row - 1, col: s.col) == x:
                let s2 = State(row: s.row - 1, col: s.col)
                if not visited.contains(s2):
                    backlog.append(s2)
                    visited.add(s2)
            if s.col > 0 and grid.get(row: s.row, col: s.col - 1) == x:
                let s2 = State(row: s.row, col: s.col - 1)
                if not visited.contains(s2):
                    backlog.append(s2)
                    visited.add(s2)
            if s.row + 1 < h and grid.get(row: s.row + 1, col: s.col) == x:
                let s2 = State(row: s.row + 1, col: s.col)
                if not visited.contains(s2):
                    backlog.append(s2)
                    visited.add(s2)
            if s.col + 1< w and grid.get(row: s.row, col: s.col + 1) == x:
                let s2 = State(row: s.row, col: s.col + 1)
                if not visited.contains(s2):
                    backlog.append(s2)
                    visited.add(s2)
    nr

struct State:
    row: int
    col: int

fn state_hash(s?: State) -> int:
    s.row * 13 + s.col * 73

fn state_eq(s1?: State, s2?: State) -> bool:
    s1.row == s2.row and s1.col == s2.col 

fn part2(grid: Grid):
    let w = grid.width()
    let h = grid.height()
    let s = 0
    let row = 0
    while row < h:
        let col = 0
        while col < w:
            if grid.get(row, col) == 0:
                s += find_hikes2(grid, row, col)
            col += 1
        row += 1
    print("Part2: {s}")

fn find_hikes2(grid: Grid, row: int, col: int) -> int:
    let w = grid.width()
    let h = grid.height()
    let nr = 0
    let backlog: List[State] = List()
    let s0 = State(row, col)
    backlog.append(s0)
    while not backlog.is_empty():
        let s = backlog.pop_front()
        let x = grid.get(row: s.row, col: s.col)
        if x == 9:
            nr += 1
        else:
            x += 1
            if s.row > 0 and grid.get(row: s.row - 1, col: s.col) == x:
                let s2 = State(row: s.row - 1, col: s.col)
                backlog.append(s2)
            if s.col > 0 and grid.get(row: s.row, col: s.col - 1) == x:
                let s2 = State(row: s.row, col: s.col - 1)
                backlog.append(s2)
            if s.row + 1 < h and grid.get(row: s.row + 1, col: s.col) == x:
                let s2 = State(row: s.row + 1, col: s.col)
                backlog.append(s2)
            if s.col + 1< w and grid.get(row: s.row, col: s.col + 1) == x:
                let s2 = State(row: s.row, col: s.col + 1)
                backlog.append(s2)
    nr

fn load_grid(filename: str) -> Grid:
    let lines = split_lines(text: read_file(filename))
    let rows: Vector[Vector[int]] = new_vector()
    for line in lines:
        let row: Vector[int] = new_vector()
        for c in line:
            row.append(digit_to_int(c))
        rows.append(row)

    Grid(rows)

class Grid:
    var rows: Vector[Vector[int]]

    pub fn width() -> int:
        rows[0].len()
    
    pub fn height() -> int:
        rows.len()

    pub fn get(row: int, col: int) -> int:
        rows[row][col]
