module main

from std import print, read_file
from base.strlib import split_lines, split_string, str_join, string_compare
from base.settype import new_str_set
from base.listtype import List
from base.graphlib import Graph, find_all_cliques_of_size, find_max_cliques
from base.sorting import sort_list

pub fn main() -> int:
	solve(filename: "23/example.txt")
	solve(filename: "23/input.txt")
	0

fn solve(filename: str):
	let g = Graph()
	for line in split_lines(text: read_file(filename)):
		let parts = split_string(text: line, sep: '-')
		g.add_edge(a: parts[0], b: parts[1])

	var s1 = 0
	let cliques_of_3 = find_all_cliques_of_size(g, k: 3)
	for clique in cliques_of_3:
		var contains_t = false
		for q in clique:
			contains_t = contains_t or q[0] == 't'
		if contains_t:
			s1 += 1
	print("[{filename}] Part 1: {s1}")

	let max_cliques = find_max_cliques(g)
	var max_clique = new_str_set()
	for clique in max_cliques:
		if clique.len() > max_clique.len():
			max_clique = clique

	let pcs: List[str] = List()
	for q in max_clique:
		pcs.append(q)
	let parts = sort_list(x: pcs, cmp: string_compare)
	let s2 = str_join(parts, sep: ",")
	print("[{filename}] Part 2: {s2}")
