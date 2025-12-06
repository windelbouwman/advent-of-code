
from std import print, read_file
from vectype import Vector, new_vector
from strlib import split_lines

pub fn main() -> int:
    let grid = load_grid(filename: "04/input.txt")
    # let grid = load_grid(filename: "04/example.txt")
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
            if match_xmas(grid, row, col, drow: 0, dcol: 1):
                s += 1
            if match_xmas(grid, row, col, drow: 0, dcol: -1):
                s += 1
            if match_xmas(grid, row, col, drow: 1, dcol: 0):
                s += 1
            if match_xmas(grid, row, col, drow: -1, dcol: 0):
                s += 1
            if match_xmas(grid, row, col, drow: 1, dcol: 1):
                s += 1
            if match_xmas(grid, row, col, drow: -1, dcol: 1):
                s += 1
            if match_xmas(grid, row, col, drow: 1, dcol: -1):
                s += 1
            if match_xmas(grid, row, col, drow: -1, dcol: -1):
                s += 1
            col += 1
        row += 1
    print("Part1: {s}")

fn match_xmas(grid: Grid, row: int, col: int, drow: int, dcol: int) -> bool:
    match_word(grid, word: "XMAS", row, col, drow, dcol)

fn part2(grid: Grid):
    let s = 0
    let w = grid.width()
    let h = grid.height()
    let row = 0
    while row < h:
        let col = 0
        while col < w:
            if match_mas(grid, row, col, drow: 1, dcol: 1) or match_mas(grid, row, col, drow: -1, dcol: -1):
                if match_mas(grid, row, col, drow: 1, dcol: -1) or match_mas(grid, row, col, drow: -1, dcol: 1):
                    s += 1
            col += 1
        row += 1
    print("Part2: {s}")

fn match_mas(grid: Grid, row: int, col: int, drow: int, dcol: int) -> bool:
    row -= drow
    col -= dcol
    match_word(grid, word: "MAS", row, col, drow, dcol)

fn match_word(grid: Grid, word: str, row: int, col: int, drow: int, dcol: int) -> bool:
    for c in word:
        if row < 0 or col < 0 or row >= grid.height() or col >= grid.width():
            return false
        elif grid.get(row, col) == c:
            row += drow
            col += dcol
        else:
            return false
    return true

fn load_grid(filename: str) -> Grid:
    let rows: Vector[Vector[char]] = new_vector()
    let lines = split_lines(text: read_file(filename))
    for line in lines:
        let row: Vector[char] = new_vector()
        for c in line:
            row.append(c)
        rows.append(row)

    Grid(rows)

class Grid:
    var rows: Vector[Vector[char]]

    pub fn width() -> int:
        rows[0].len()
    
    pub fn height() -> int:
        rows.len()

    pub fn get(row: int, col: int) -> char:
        rows[row][col]
