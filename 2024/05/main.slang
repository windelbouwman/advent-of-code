
from std import print, read_file
from strlib import split_lines, split_string, str_to_int
from datatypes import List
from graphlib import DiGraph
from settype import new_str_set

pub fn main() -> int:
    let puzzle = load_puzzle(filename: "05/input.txt")
    # let puzzle = load_puzzle(filename: "05/example.txt")
    part1(puzzle)
    part2(puzzle)
    0

fn part1(puzzle: Puzzle):
    let s = 0
    for page in puzzle.pages:
        if is_valid(g: puzzle.g, page):
            s += str_to_int(page[page.len() / 2])
    print("Part1: {s}")

fn is_valid(g: DiGraph, page: List[str]) -> bool:
    let used = new_str_set()
    for x in page:
        used.add(x)
    let visited = new_str_set()
    for x in page:
        for dep in g.successors(x):
            if used.contains(dep) and not visited.contains(dep):
                return false
        visited.add(x)
    true

fn part2(puzzle: Puzzle):
    let s = 0
    for page in puzzle.pages:
        if not is_valid(g: puzzle.g, page):
            page = sort_page(g: puzzle.g, page)
            s += str_to_int(page[page.len() / 2])
    print("Part2: {s}")

fn sort_page(g: DiGraph, page: List[str]) -> List[str]:
    let res: List[str] = List()
    let used = new_str_set()
    for x in page:
        used.add(x)
    let visited = new_str_set()
    while not page.is_empty():
        let x = page.pop_front()
        let solved = true
        for dep in g.successors(x):
            if used.contains(dep) and not visited.contains(dep):
                page.append(x)
                solved = false
                break
        if solved:
            visited.add(x)
            res.append(x)
    res

fn load_puzzle(filename: str) -> Puzzle:
    let g = DiGraph()
    let pages: List[List[str]] = List()
    let lines = split_lines(text: read_file(filename))
    let section = 0
    for line in lines:
        if line == "":
            section += 1
        elif section == 0:
            let parts = split_string(text: line, sep: '|')
            g.add_edge(src: parts[1], dst: parts[0])
        elif section == 1:
            let page = split_string(text: line, sep: ',')
            pages.append(page)
    Puzzle(g, pages)

struct Puzzle:
    g: DiGraph
    pages: List[List[str]]
