
.SUFFIXES:
.PRECIOUS: ${BUILDDIR}/%.c

SLANG_ROOT ?= ../sauce-os

BUILDDIR=build
SLANG_BUILD=${SLANG_ROOT}/build
SLANGC=$(SLANG_BUILD)/x86/apps/compiler.exe
LDFLAGS ?= --dynamic-linker /lib64/ld-linux-x86-64.so.2

AOC_LIB_SRCS=aoclib.slang
CFLAGS=-I${SLANG_FOLDER}/runtime

.PHONY: all format
all: ${BUILDDIR}/day01.exe \
  ${BUILDDIR}/day02.exe \
  ${BUILDDIR}/day03.exe \
  ${BUILDDIR}/day04.exe \
  ${BUILDDIR}/day05.exe \
  ${BUILDDIR}/day06.exe \
  ${BUILDDIR}/day07.exe \
  ${BUILDDIR}/day08.exe \
  ${BUILDDIR}/day09.exe \
  ${BUILDDIR}/day10.exe \
  ${BUILDDIR}/day11.exe \
  ${BUILDDIR}/day12.exe \
  ${BUILDDIR}/day13.exe \
  ${BUILDDIR}/day14.exe \
  ${BUILDDIR}/day15.exe \
  ${BUILDDIR}/day16.exe \
  ${BUILDDIR}/day17.exe \
  ${BUILDDIR}/day18.exe \
  ${BUILDDIR}/day19.exe \
  ${BUILDDIR}/day20.exe \
  ${BUILDDIR}/day22.exe \
  ${BUILDDIR}/day23.exe \
  ${BUILDDIR}/day24.exe

${BUILDDIR}/day%.exe: ${BUILDDIR}/day%.o ${SLANG_BUILD}/x86/libslangrt.so ${SLANG_BUILD}/slangrt_main.o ${SLANG_BUILD}/x86/libbase.so ${BUILDDIR}/libaoc.o
	ld ${LDFLAGS} -o $@ -L ${SLANG_BUILD}/x86 -rpath ${SLANG_BUILD}/x86 /usr/lib/crt1.o /usr/lib/crti.o $< ${SLANG_BUILD}/slangrt_main.o ${BUILDDIR}/libaoc.o -lbase -lslangrt -lm -lc /usr/lib/crtn.o

${BUILDDIR}/day%.o: ${BUILDDIR}/day%.c
	gcc ${CFLAGS} -c -o $@ $<

${BUILDDIR}/day%.o: ./%/main.slang ${SLANG_BUILD}/x86/libbase.json ${BUILDDIR}/libaoc.json | ${BUILDDIR}
	${SLANGC} -Wunused --backend-x86 --add-import ${SLANG_BUILD}/x86/libbase.json --add-import ${BUILDDIR}/libaoc.json -o $@ $<

${BUILDDIR}/libaoc.o ${BUILDDIR}/libaoc.json: ${AOC_LIB_SRCS} ${SLANG_BUILD}/x86/libbase.json | ${BUILDDIR}
	${SLANGC} --backend-x86 --add-import ${SLANG_BUILD}/x86/libbase.json --gen-export ${BUILDDIR}/libaoc.json -o ${BUILDDIR}/libaoc.o ${AOC_LIB_SRCS}

${BUILDDIR}:
	mkdir -p ${BUILDDIR}

format:
	$(SLANG_BUILD)/x86/apps/format.exe --in-place **/*.slang

profile: ${BUILDDIR}/day23.exe
	valgrind --tool=callgrind --callgrind-out-file=${BUILDDIR}/callgrind.out $<
	kcachegrind ${BUILDDIR}/callgrind.out

clean:
	rm -rf ${BUILDDIR}
