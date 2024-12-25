
.SUFFIXES:
.PRECIOUS: ${BUILDDIR}/%.c

BUILDDIR=build
SLANG_FOLDER=../sauce-os
BASE_LIB_SRCS := $(wildcard ${SLANG_FOLDER}/Libs/base/*.slang)
BASE_LIB_SRCS += ${SLANG_FOLDER}/runtime/std.slang
REGEX_LIB_SRCS := $(wildcard ${SLANG_FOLDER}/Libs/regex/*.slang)
AOC_LIB_SRCS=aoclib.slang
CFLAGS=-I${SLANG_FOLDER}/runtime

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
  ${BUILDDIR}/day12.exe ${BUILDDIR}/py/day12.py \
  ${BUILDDIR}/day13.exe \
  ${BUILDDIR}/day14.exe \
  ${BUILDDIR}/day15.exe \
  ${BUILDDIR}/day16.exe \
  ${BUILDDIR}/day17.exe \
  ${BUILDDIR}/day18.exe \
  ${BUILDDIR}/day19.exe \
  ${BUILDDIR}/day20.exe \
  ${BUILDDIR}/day21.exe \
  ${BUILDDIR}/day22.exe

${BUILDDIR}/day%.exe: ${BUILDDIR}/day%.o ${BUILDDIR}/slangrt.o ${BUILDDIR}/aoclib-c.o ${BUILDDIR}/libbase.o ${BUILDDIR}/libregex.o ${BUILDDIR}/libaoc.o
	gcc -o $@ $< ${BUILDDIR}/slangrt.o ${BUILDDIR}/aoclib-c.o ${BUILDDIR}/libbase.o ${BUILDDIR}/libregex.o  ${BUILDDIR}/libaoc.o -lm

${BUILDDIR}/day%.o: ${BUILDDIR}/day%.c
	gcc ${CFLAGS} -c -o $@ $<

${BUILDDIR}/lib%.o: ${BUILDDIR}/lib%.c
	gcc ${CFLAGS} -c -o $@ $<

${BUILDDIR}/day%.c: ./%/main.slang ${BUILDDIR}/libbase.json ${BUILDDIR}/libregex.json ${BUILDDIR}/libaoc.json | ${BUILDDIR}
	slangc --backend-c --add-import ${BUILDDIR}/libbase.json --add-import ${BUILDDIR}/libregex.json --add-import ${BUILDDIR}/libaoc.json -o $@ $<

${BUILDDIR}/py/day%.py: ./%/main.slang ${BUILDDIR}/py/slangrt.py ${BUILDDIR}/py/libbase.json ${BUILDDIR}/py/libbase.py | ${BUILDDIR}/py
	slangc --backend-py --add-import ${BUILDDIR}/py/libbase.json -o $@ $<

${BUILDDIR}/slangrt.o: ${SLANG_FOLDER}/runtime/slangrt.c | ${BUILDDIR}
	gcc ${CFLAGS} -c -o $@ $<

${BUILDDIR}/aoclib-c.o: aoclib-c.c | ${BUILDDIR}
	gcc ${CFLAGS} -c -o $@ $<

${BUILDDIR}/libaoc.c ${BUILDDIR}/libaoc.json: ${AOC_LIB_SRCS} ${BUILDDIR}/libbase.json | ${BUILDDIR}
	slangc --backend-c --add-import ${BUILDDIR}/libbase.json --gen-export ${BUILDDIR}/libaoc.json -o ${BUILDDIR}/libaoc.c ${AOC_LIB_SRCS}

${BUILDDIR}/libregex.c ${BUILDDIR}/libregex.json: ${REGEX_LIB_SRCS} ${BUILDDIR}/libbase.json ${SLANGC_DEPS} | ${BUILDDIR}
	slangc --backend-c --gen-export ${BUILDDIR}/libregex.json -o ${BUILDDIR}/libregex.c --add-import ${BUILDDIR}/libbase.json ${REGEX_LIB_SRCS}

${BUILDDIR}/libbase.c ${BUILDDIR}/libbase.json: ${BASE_LIB_SRCS} | ${BUILDDIR}
	slangc --backend-c --gen-export ${BUILDDIR}/libbase.json -o ${BUILDDIR}/libbase.c ${BASE_LIB_SRCS}

${BUILDDIR}/py/libbase.py ${BUILDDIR}/py/libbase.json: ${BASE_LIB_SRCS} | ${BUILDDIR}/py
	slangc --backend-py --gen-export ${BUILDDIR}/py/libbase.json -o ${BUILDDIR}/py/libbase.py ${BASE_LIB_SRCS}

${BUILDDIR}/py/slangrt.py: ${SLANG_FOLDER}/runtime/slangrt.py | ${BUILDDIR}/py
	cp $< $@

${BUILDDIR}:
	mkdir -p ${BUILDDIR}

${BUILDDIR}/py:
	mkdir -p ${BUILDDIR}/py

profile: ${BUILDDIR}/day11.exe
	valgrind --tool=callgrind --callgrind-out-file=${BUILDDIR}/callgrind.out $<
	kcachegrind ${BUILDDIR}/callgrind.out

clean:
	rm -rf ${BUILDDIR}
