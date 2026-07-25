module main

from std import print, read_file, str_len
from base.utils import panic
from base.strlib import split_lines, split_string, trim, str_to_int
from base.listtype import List
from base.optiontype import option_unwrap
from base.hashmap import HashMap, new_hashmap_str
from base.graphlib import DiGraph, topological_sort

pub fn main() -> int:
	solve(filename: "24/example.txt")
	solve(filename: "24/example2.txt")
	solve(filename: "24/input.txt")
	0

fn solve(filename: str):
	let wires: HashMap[str,int] = new_hashmap_str()
	let gates: List[Gate] = List()
	var section = 0
	for line in split_lines(text: read_file(filename)):
		if str_len(text: line) == 0:
			section += 1
		else:
			if section == 0:
				let parts = split_string(text: line, sep: ':')
				let value = str_to_int(trim(parts[1]))
				wires.insert(key: parts[0], value)
			elif section == 1:
				let parts = split_string(text: line, sep: ' ')
				let a = parts[0]
				let b = parts[2]
				let out = parts[4]
				let operator = if parts[1] == "XOR":
					Operator.Xor()
				elif parts[1] == "OR":
					Operator.Or()
				elif parts[1] == "AND":
					Operator.And()
				else:
					panic("Invalid operator: {parts[1]}")
				gates.append(Gate(a, b, out, operator))

	# Build dependency graph:
	let g = DiGraph()
	let gates_by_output: HashMap[str,Gate] = new_hashmap_str()
	for gate in gates:
		g.add_edge(src: gate.a, dst: gate.out)
		g.add_edge(src: gate.b, dst: gate.out)
		gates_by_output.insert(key: gate.out, value: gate)

	let evaluation_order = option_unwrap(topological_sort(g))
	for wire in evaluation_order:
		# print("Wire: {wire}")
		if gates_by_output.contains(key: wire):
			let gate = gates_by_output.get(key: wire)
			let a = wires.get(key: gate.a)
			let b = wires.get(key: gate.b)
			let value = case gate.operator:
				Or:
					a | b
				And:
					a & b
				Xor:
					a ^ b
			wires.insert(key: wire, value)

	var z = 0
	var i = 0
	loop:
		let wire = if i < 10:
			"z0{i}"
		else:
			"z{i}"
		if wires.contains(key: wire):
			let bit = wires.get(key: wire)
			z = z | (bit << i)
		else:
			break
		i += 1

	let s1 = z
	print("[{filename}] Part 1: {s1}")


	let s2 = 0
	print("[{filename}] Part 2: {s2}")

struct Gate:
	a: str
	b: str
	out: str
	operator: Operator

enum Operator:
	Or
	And
	Xor
