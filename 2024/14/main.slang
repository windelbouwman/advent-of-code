
from std import print, read_file
from strlib import split_lines, str_to_int
from math import modulo
from regex import find_all, Match
from hashmap import HashMap, new_hashmap_int
from settype import Set, new_int_set
from functools import map
from datatypes import List

pub fn main() -> int:
    # let robots = load_robots(filename: "14/example.txt")
    let robots = load_robots(filename: "14/input.txt")
    part_1(robots, x_max: 101, y_max: 103)
    part_2(robots, x_max: 101, y_max: 103)
    # part_1(robots, x_max: 11, y_max: 7)
    # part_2(robots, x_max: 11, y_max: 7)
    0

fn part_1(robots: List[Robot], x_max: int, y_max: int):
    move_robots(robots, x_max, y_max, N: 100)
    let q_counter = count_quadrants(robots, x_max, y_max)

    let s = 1
    let q = 0
    while q < 4:
        print("Qaudrant: {q_counter.get(key: q)}")
        s *= q_counter.get(key: q)
        q += 1

    print("Part1: {s}")

fn count_quadrants(robots: List[Robot], x_max: int, y_max: int) -> HashMap[int, int]:
    let q_counter: HashMap[int, int] = new_hashmap_int()
    q_counter.insert(key: 0, value: 0)
    q_counter.insert(key: 1, value: 0)
    q_counter.insert(key: 2, value: 0)
    q_counter.insert(key: 3, value: 0)
    for robot in robots:
        let quadrant = get_quadrant(robot, x_max, y_max)
        if quadrant < 0:
            continue
        q_counter.insert(key: quadrant, value: q_counter.get(key: quadrant) + 1)
    q_counter

fn get_quadrant(robot: Robot, x_max: int, y_max: int) -> int:
    # Determine quadrant:
    let quadrant_x = if robot.px < x_max / 2:
        0
    elif robot.px > x_max / 2:
        2
    else:
        return -1
    let quadrant_y = if robot.py < y_max / 2:
        0
    elif robot.py > y_max / 2:
        1
    else:
        return -1
    quadrant_x + quadrant_y

fn part_2(robots: List[Robot], x_max: int, y_max: int):
    let n = 0

    let x_mid = x_max / 2
    while n < 100000:
        move_robots(robots, x_max, y_max, N: 1)
        n += 1
        if maybe_tree(robots, x_max, y_max):
            print("Round: {n}")
            draw_robots(robots, x_max, y_max)
            print("")
            break

fn maybe_tree(robots: List[Robot], x_max: int, y_max: int) -> bool:
    let spots: Set[int] = new_int_set()
    for robot in robots:
        let s = robot.px + robot.py * x_max
        spots.add(s)
    robots.len() - spots.len() == 0

fn get_robot_lines(robots: List[Robot], x_max: int, y_max: int) -> List[str]:
    let lines: List[str] = List()
    let y = 0
    while y < y_max:
        let line = ""
        let x = 0
        while x < x_max:
            let c = '.'
            for robot in robots:
                if robot.px == x and robot.py == y:
                    c = 'X'
                    break
            line = "{line}{c}"                
            x += 1
        y += 1
        lines.append(line)
    lines

fn draw_robots(robots: List[Robot], x_max: int, y_max: int):
    for line in get_robot_lines(robots, x_max, y_max):
        print(line)

fn move_robots(robots: List[Robot], x_max: int, y_max: int, N: int):
    for robot in robots:
        robot.px = wrap(robot.px + robot.vx * N, max: x_max)
        robot.py = wrap(robot.py + robot.vy * N, max: y_max)

fn wrap(x?: int, max: int) -> int:
    x = modulo(value: x, divisor: max)
    if x < 0:
        x += max
    x


fn load_robots(filename: str) -> List[Robot]:
    let lines = split_lines(text: read_file(filename))
    let robots: List[Robot] = List()
    for line in lines:
        let numbers = parse_numbers(line)
        let px = numbers[0]
        let py = numbers[1]
        let vx = numbers[2]
        let vy = numbers[3]
        let robot = Robot(px, py, vx, vy)
        robots.append(robot)
    robots

fn parse_numbers(line: str) -> List[int]:
    map(values: find_all(pattern: "-?[0-9]+", text: line), function: match_to_int)

fn match_to_int(m: Match) -> int:
    str_to_int(m.text)

struct Robot:
    px: int
    py: int
    vx: int
    vy: int
