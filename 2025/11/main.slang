from std import print, read_file, get_arg
from strlib import trim, split_lines, split_string
from graphlib import DiGraph
from vectype import Vector, new_vector
from hashmap import HashMap, new_hashmap_str
from utils import panic

pub fn main() -> int:
	let g = read_graph(filename: get_arg(arg: 0))
	part1(g)
	part2(g)
	0

fn read_graph(filename: str) -> DiGraph:
	let text = read_file(filename)
	let g = DiGraph()
	for line in split_lines(text):
		let parts = split_string(text: trim(line), sep: ':')
		let src = parts[0]
		for dst in split_string(text: trim(parts[1]), sep: ' '):
			g.add_edge(src, dst)
	g

fn part1(g: DiGraph):
	let n_steps = get_n_paths(g, from_node: "you", to_node: "out")
	print("Part 1: {n_steps}")

fn part2(g: DiGraph):
	let n1 = get_n_paths(g, from_node: "svr", to_node: "fft")
	let n2 = get_n_paths(g, from_node: "fft", to_node: "dac")
	let n3 = get_n_paths(g, from_node: "dac", to_node: "out")
	let n_p1 = n1 * n2 * n3

	let n4 = get_n_paths(g, from_node: "svr", to_node: "dac")
	let n5 = get_n_paths(g, from_node: "dac", to_node: "fft")
	let n6 = get_n_paths(g, from_node: "fft", to_node: "out")
	let n_p2 = n4*n5*n6

	let n_steps = n_p1 + n_p2
	print("Part 2: {n_steps}")

fn get_n_paths(g: DiGraph, from_node: str, to_node: str) -> int:
	""" Find out how many paths exist between two nodes """
	let x = new_hashmap_str()
	x.insert(key: to_node, value: 1)
	while not x.contains(key: from_node):
		# Iterate:
		let old_size = x.len()
		for n in g.nodes:
			if not x.contains(key: n):
				var n_paths = 0
				var ok = true
				for s in g.successors(n):
					if x.contains(key: s):
						n_paths += x.get(key: s)
					else:
						ok = false
				if ok:
					x.insert(key: n, value: n_paths)
		if old_size == x.len():
			panic("No path from {from_node} to {to_node}")
	x.get(key: from_node)
