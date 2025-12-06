
from std import print, read_file, str_len
from strlib import split_lines
from utils import panic
from datatypes import List
from vectype import Vector, new_vector

pub fn main() -> int:
    # part_1(filename: "15/example2.txt")
    part_1(filename: "15/example1.txt")
    part_2(filename: "15/example1.txt")
    part_1(filename: "15/input.txt")
    part_2(filename: "15/input.txt")
    # part_2(filename: "15/example3.txt")
    0

fn part_1(filename: str):
    let puzzle = load_puzzle(filename, wide: false)
    let s = 0
    let p = puzzle.p0
    for move in puzzle.moves:
        case move:
            Up:
                if try_move1(grid: puzzle.grid, p, drow: -1, dcol: 0):
                    p.row -= 1
            Left:
                if try_move1(grid: puzzle.grid, p, drow: 0, dcol: -1):
                    p.col -= 1
            Right:
                if try_move1(grid: puzzle.grid, p, drow: 0, dcol: 1):
                    p.col += 1
            Down:
                if try_move1(grid: puzzle.grid, p, drow: 1, dcol: 0):
                    p.row += 1
    
    let row = 0
    while row < puzzle.grid.height():
        let col = 0
        while col < puzzle.grid.width():
            let c = puzzle.grid.get(Position(row, col))
            if c == 'O':
                let coordinate = row * 100 + col
                s += coordinate
            col += 1
        row += 1
    print("[{filename}] Part 1: {s}")

fn try_move1(grid: Grid, p: Position, drow: int, dcol: int) -> bool:
    let p1 = Position(row: p.row + drow, col: p.col + dcol)
    let c = grid.get(p1)
    if c == '#':
        false
    elif c == '.':
        true
    elif c == 'O':
        if try_move1(grid, p: p1, drow, dcol):
            let p2 = Position(row: p.row + drow * 2, col: p.col + dcol * 2)
            grid.set(p2, value: 'O')
            grid.set(p1, value: '.')
            true
        else:
            false
    else:
        panic("No valid cell: {c}")

fn part_2(filename: str):
    let puzzle = load_puzzle(filename, wide: true)
    let p = puzzle.p0
    for move in puzzle.moves:
        case move:
            Up:
                try_move2(grid: puzzle.grid, p, drow: -1, dcol: 0)
            Left:
                try_move2(grid: puzzle.grid, p, drow: 0, dcol: -1)
            Right:
                try_move2(grid: puzzle.grid, p, drow: 0, dcol: 1)
            Down:
                try_move2(grid: puzzle.grid, p, drow: 1, dcol: 0)
        
    let s = 0
    let row = 0
    while row < puzzle.grid.height():
        let col = 0
        while col < puzzle.grid.width():
            let c = puzzle.grid.get(Position(row, col))
            if c == '[':
                let coordinate = row * 100 + col
                s += coordinate
            col += 1
        row += 1
    print("[{filename}] Part 2: {s}")

fn try_move2(grid: Grid, p: Position, drow: int, dcol: int):
    if can_move2(grid, p, drow, dcol):
        do_move2(grid, p, drow, dcol)

fn can_move2(grid: Grid, p: Position, drow: int, dcol: int) -> bool:
    """ Test if we can move! """
    let p1 = Position(row: p.row + drow, col: p.col + dcol)
    let c = grid.get(p1)
    if c == '#':
        false
    elif c == '.':
        true
    elif c == '[':
        let p2 = Position(row: p1.row, col: p1.col + 1)  # ']'
        if drow == 0 and dcol == 1: # Right
            can_move2(grid, p: p2, drow, dcol)
        elif dcol == 0: # Up/down
            can_move2(grid, p: p1, drow, dcol) and can_move2(grid, p: p2, drow, dcol)
        else:
            panic("Invalid combination of drow and dcol 1")
    elif c == ']':
        let p2 = Position(row: p1.row, col: p1.col - 1)  # '['
        if drow == 0 and dcol == -1:
            can_move2(grid, p: p2, drow, dcol)
        elif dcol == 0:
            can_move2(grid, p: p1, drow, dcol) and can_move2(grid, p: p2, drow, dcol)
        else:
            panic("Invalid combination of drow and dcol 2")
    else:
        panic("No valid cell: {c}")

fn do_move2(grid: Grid, p: Position, drow: int, dcol: int):
    let p1 = Position(row: p.row + drow, col: p.col + dcol)
    let c = grid.get(p1)
    if c == '#':
        panic("Cannot move!")
    elif c == '.':
        pass
    elif c == '[':
        let p2 = Position(row: p1.row, col: p1.col + 1)  # ']'
        grid.set(p1, value: '.')
        grid.set(p2, value: '.')
        do_move2(grid, p: p2, drow, dcol)
        do_move2(grid, p: p1, drow, dcol)
        grid.set(p1, value: '[')
        grid.set(p2, value: ']')
    elif c == ']':
        let p2 = Position(row: p1.row, col: p1.col - 1)  # '['
        grid.set(p1, value: '.')
        grid.set(p2, value: '.')
        do_move2(grid, p: p2, drow, dcol)
        do_move2(grid, p: p1, drow, dcol)
        grid.set(p1, value: ']')
        grid.set(p2, value: '[')
    else:
        panic("No valid cell: {c}")

    p.row += drow
    p.col += dcol


fn load_puzzle(filename: str, wide: bool) -> Puzzle:
    let moves: List[Direction] = List()
    let rows: Vector[Vector[char]] = new_vector()
    let p0 = Position(row: 0, col: 0)
    let section = 0
    let row_nr = 0
    
    for line in split_lines(text: read_file(filename)):
        if str_len(text: line) == 0:
            section += 1
        else:
            if section == 0:
                let row: Vector[char] = new_vector()
                let col_nr = 0
                for c in line:
                    if c == '@':
                        p0.row = row_nr
                        p0.col = col_nr
                        c = '.'

                    if wide:
                        if c == 'O':
                            row.append('[')
                            row.append(']')
                        else:
                            row.append(c)
                            row.append(c)
                        col_nr += 2
                    else:
                        row.append(c)
                        col_nr += 1
                rows.append(row)
                row_nr += 1
            elif section == 1:
                for c in line:
                    let move = if c == '<':
                        Direction.Left()
                    elif c == '>':
                        Direction.Right()
                    elif c == '^':
                        Direction.Up()
                    elif c == 'v':
                        Direction.Down()
                    else:
                        panic("Invalid direction: {c}")
                    moves.append(move)

    let grid = Grid(rows)
    Puzzle(grid, p0, moves)

struct Puzzle:
    grid: Grid
    p0: Position
    moves: List[Direction]

struct Position:
    row: int
    col: int

enum Direction:
    Up
    Down
    Left
    Right

class Grid:
    var rows: Vector[Vector[char]]

    pub fn width() -> int:
        rows[0].len()
    
    pub fn height() -> int:
        rows.len()

    pub fn get(p?: Position) -> char:
        rows[p.row][p.col]

    pub fn set(p?: Position, value: char):
        rows[p.row].set(index: p.col, value)

    fn dump(p?: Position):
        let row_nr = 0
        for row in rows:
            let txt = ""
            let col_nr = 0
            for c in row:
                if p.row == row_nr and p.col == col_nr:
                    c = '@'
                txt = txt + "{c}"
                col_nr += 1
            print(txt)
            row_nr += 1
        print("")
