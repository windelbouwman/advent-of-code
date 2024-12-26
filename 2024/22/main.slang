
from std import print, read_file, str_len
from strlib import split_lines, str_to_int, digit_to_int
from datatypes import List
from hashmap import HashMap, new_hashmap
from functools import map

pub fn main() -> int:
    solve(filename: "22/example.txt")
    solve(filename: "22/example2.txt")
    solve(filename: "22/input.txt")
    0

fn solve(filename: str):
    let numbers = map(values: split_lines(text: read_file(filename)), function: str_to_int)
    let s1 = 0
    for value in numbers:
        let y = scramble(value, count: 2000)
        s1 += y
    print("[{filename}] Part 1: {s1}")

    # Test value:
    let m = calc_diff_map(value: 123)
    let s = DiffSequence(d1: -1, d2: -1, d3: 0, d4: 2)
    print("cost: {m.get(key: s)}")
    # assert m.get(key: s) = 6

    # Calculate 
    let diff_maps: List[HashMap[DiffSequence,int]] = List()
    for value in numbers:
        let m = calc_diff_map(value)
        diff_maps.append(m)

    let total_cost: HashMap[DiffSequence,int] = new_hashmap(f_hash: diff_sequence_hash, f_eq: diff_sequence_eq)
    let s2 = 0
    for diff_map in diff_maps:
        for ds in diff_map:
            if not total_cost.contains(key: ds):
                let total = 0
                for diff_map2 in diff_maps:
                    if diff_map2.contains(key: ds):
                        total += diff_map2.get(key: ds)
                # print("Total: {total}")
                if total > s2:
                    s2 = total
                total_cost.insert(key: ds, value: total)
    

    print("[{filename}] Part 2: {s2}")

fn calc_diff_map(value: int) -> HashMap[DiffSequence,int]:
    # Determine differences
    # x = 123
    let m: HashMap[DiffSequence,int] = new_hashmap(f_hash: diff_sequence_hash, f_eq: diff_sequence_eq)
    let d1 = 0
    let d2 = 0
    let d3 = 0
    let d4 = 0
    let price2 = 0
    let i = 0
    while i < 2000:
        let price = get_one_digit(value)
        if i > 0:
            d1 = d2
            d2 = d3
            d3 = d4
            d4 = price - price2
        price2 = price
        # print("i={i} x={value} {price} d={d1}")
        if i > 3:
            let s = DiffSequence(d1, d2, d3, d4)
            if not m.contains(key: s):
                m.insert(key: s, value: price)

        i += 1
        value = cycle(value)
    m

struct DiffSequence:
    d1: int
    d2: int
    d3: int
    d4: int

fn diff_sequence_hash(x?: DiffSequence) -> int:
    (x.d1 + 10) * 8000 + (x.d2 + 10) * 400 + (x.d3 + 10) * 20 + (x.d4 + 10)

fn diff_sequence_eq(a?: DiffSequence, b?: DiffSequence) -> bool:
    a.d1 == b.d1 and a.d2 == b.d2 and a.d3 == b.d3 and a.d4 == b.d4

fn get_one_digit(value: int) -> int:
    let text = str(value)
    let n = str_len(text)
    let c = text[n - 1]
    digit_to_int(c)

fn scramble(value: int, count: int) -> int:
    while count > 0:
        count -= 1
        value = cycle(value)
    value

fn cycle(value: int) -> int:
    value = ((value * 64) ^ value) & 0xFFFFFF
    value = ((value / 32) ^ value) & 0xFFFFFF
    value = ((value * 2048) ^ value) & 0xFFFFFF
    value
