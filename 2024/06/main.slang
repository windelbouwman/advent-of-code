
from std import print, read_file, str_len
from vectype import Vector, new_vector
from strlib import split_lines
from utils import panic
from settype import new_str_set
from aoclib import Direction, turn_right, dir_hash

pub fn main() -> int:
    let grid = load_grid(filename: "06/input.txt")
    # let grid = load_grid(filename: "06/example.txt")
    let s = find_start(grid)
    part1(grid, s)
    part2(grid, s)
    0

fn part1(grid: Grid, s: State):
    s = copy_state(s)
    let visited = new_str_set()
    let w = grid.width
    print("W={w}")
    let h = grid.height
    let N = w * h
    loop:
        let key = "{s.pos}"
        visited.add(key)

        # New position:
        let row = s.pos / w
        let col = s.pos - (row * w)
        case s.dir:
            Up:
                row -= 1
            Down:
                row += 1
            Left:
                col -= 1
            Right:
                col += 1
        
        # Check out of grid:
        if row < 0 or row >= h or col < 0 or col >= w:
            break
        
        let pos = row * w + col

        let c = grid.get(pos)
        if c == '.':
            s.pos = pos
        elif c == '#':
            s.dir = turn_right(s.dir)
        else:
            panic("Bad char: {c}")
    print("Part1: {visited.len()}")

fn part2(grid: Grid, s: State):
    let state_grid = new_state_grid(grid)
    let s0 = s
    s = copy_state(s)
    let options = new_str_set()
    let w = grid.width
    let h = grid.height
    let N = w * h
    loop:
        # New position:
        let row = s.pos / w
        let col = s.pos - (row * w)
        case s.dir:
            Up:
                row -= 1
            Down:
                row += 1
            Left:
                col -= 1
            Right:
                col += 1

        # Check out of grid:
        if row < 0 or row >= h or col < 0 or col >= w:
            break
        
        let pos = row * w + col

        # Check next cell:
        let c = grid.get(pos)
        if c == '.':
            # print("Check loop when blocking {s.row},{s.col}")
            let key = "{pos}"
            if not options.contains(key):
                grid.set(pos, value: '#')
                if would_loop(grid, state_grid, s: s0):
                    options.add(key)
                grid.set(pos, value: '.')
            s.pos = pos
        elif c == '#':
            s.dir = turn_right(s.dir)
        else:
            panic("Bad char: {c}")
    print("Part2: {options.len()}")

fn would_loop(grid: Grid, state_grid: StateGrid, s: State) -> bool:
    """ Check if we would loop if we would need to turn and step once """
    state_grid.clear()
    let w = grid.width
    let h = grid.height
    let N = w * h
    s = copy_state(s)
    loop:
        # New position:
        let row = s.pos / w
        let col = s.pos - (row * w)
        case s.dir:
            Up:
                row -= 1
            Down:
                row += 1
            Left:
                col -= 1
            Right:
                col += 1

        # Check out of grid:
        if row < 0 or row >= h or col < 0 or col >= w:
            break
        
        let pos = row * w + col
        # Check out of grid:
        if pos < 0 or pos >= N:
            break

        # Check next cell:
        let c = grid.get(pos)
        if c == '.': # Move ahead
            s.pos = pos
        elif c == '#': # Turn
            if state_grid.contains(s):
                return true
            else:
                state_grid.add(s)
            s.dir = turn_right(s.dir)
        else:
            panic("Bad char: {c}")
    false

fn find_start(grid: Grid) -> State:
    let pos = 0
    while pos < grid.width * grid.height:
        if grid.get(pos) == '^':
            let s = State(pos, dir: Direction.Up())
            grid.set(pos, value: '.')
            return s
        pos += 1
    panic("Start not found!")

fn load_grid(filename: str) -> Grid:
    let cells: Vector[char] = new_vector()
    let lines = split_lines(text: read_file(filename))
    let width = str_len(text: lines[0])
    let height = lines.len()
    for line in lines:
        let row: Vector[char] = new_vector()
        for c in line:
            cells.append(c)
    Grid(width, height, cells)

struct State:
    pos: int
    dir: Direction

fn copy_state(s?: State) -> State:
    State(pos: s.pos, dir: s.dir)

class Grid:
    pub var width: int
    pub var height: int
    pub var cells: Vector[char]

    pub fn get(pos: int) -> char:
        cells[pos]

    pub fn set(pos: int, value: char):
        cells.set(index: pos, value)

fn new_state_grid(grid: Grid) -> StateGrid:
    let data: Vector[int] = new_vector()
    let i = 0
    while i < grid.cells.len():
        data.append(0)
        i += 1
    StateGrid(data)

class StateGrid:
    var data: Vector[int]

    pub fn contains(s?: State) -> bool:
        let value = data[s.pos]
        let mask = 1 << dir_hash(s.dir)
        value & mask != 0

    pub fn add(s?: State):
        let mask = 1 << dir_hash(s.dir)
        let value = data[s.pos]
        value = value | mask
        data.set(index: s.pos, value)

    pub fn clear():
        let index = 0
        while index < data.len():
            data.set(index, value: 0)
            index += 1
