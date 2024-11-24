
.SUFFIXES:
.PRECIOUS: ${BUILDDIR}/%.c

BUILDDIR=build
SLANG_FOLDER=./sauce-os
BASE_LIB_SRCS := $(wildcard ${SLANG_FOLDER}/Libs/base/*.slang)
BASE_LIB_SRCS += ${SLANG_FOLDER}/runtime/std.slang
AOC_LIB_SRCS=aoclib.slang
CFLAGS=-I${SLANG_FOLDER}/runtime

all: ${BUILDDIR}/day01.exe ${BUILDDIR}/day02.exe ${BUILDDIR}/day03.exe ${BUILDDIR}/day04.exe ${BUILDDIR}/day05.exe ${BUILDDIR}/day06.exe ${BUILDDIR}/day07.exe \
  ${BUILDDIR}/day08.exe ${BUILDDIR}/day09.exe ${BUILDDIR}/day10.exe \
  ${BUILDDIR}/day11.exe ${BUILDDIR}/day12.exe \
  ${BUILDDIR}/day13.exe \
  ${BUILDDIR}/day15.exe

${BUILDDIR}/day%.exe: ${BUILDDIR}/day%.o ${BUILDDIR}/slangrt.o ${BUILDDIR}/aoclib-c.o ${BUILDDIR}/libbase.o ${BUILDDIR}/libaoc.o
	gcc -o $@ $< ${BUILDDIR}/slangrt.o ${BUILDDIR}/aoclib-c.o ${BUILDDIR}/libbase.o ${BUILDDIR}/libaoc.o -lm

${BUILDDIR}/day%.o: ${BUILDDIR}/day%.c
	gcc ${CFLAGS} -c -o $@ $<

${BUILDDIR}/lib%.o: ${BUILDDIR}/lib%.c
	gcc ${CFLAGS} -c -o $@ $<

${BUILDDIR}/day%.c: ./%/main.slang ${BUILDDIR}/libbase.json ${BUILDDIR}/libaoc.json | ${BUILDDIR}
	slangc --backend-c --add-import ${BUILDDIR}/libbase.json --add-import ${BUILDDIR}/libaoc.json -o $@ $<

${BUILDDIR}/slangrt.o: ${SLANG_FOLDER}/runtime/slangrt.c | ${BUILDDIR}
	gcc ${CFLAGS} -c -o $@ $<

${BUILDDIR}/aoclib-c.o: aoclib-c.c | ${BUILDDIR}
	gcc ${CFLAGS} -c -o $@ $<

${BUILDDIR}/libaoc.c ${BUILDDIR}/libaoc.json: ${AOC_LIB_SRCS} ${BUILDDIR}/libbase.json | ${BUILDDIR}
	slangc --backend-c --add-import ${BUILDDIR}/libbase.json --gen-export ${BUILDDIR}/libaoc.json -o ${BUILDDIR}/libaoc.c ${AOC_LIB_SRCS}

${BUILDDIR}/libbase.c ${BUILDDIR}/libbase.json: ${BASE_LIB_SRCS} | ${BUILDDIR}
	slangc --backend-c --gen-export ${BUILDDIR}/libbase.json -o ${BUILDDIR}/libbase.c ${BASE_LIB_SRCS}

${BUILDDIR}:
	mkdir -p ${BUILDDIR}

clean:
	rm -rf ${BUILDDIR}
