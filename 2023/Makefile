
BUILDDIR=build
SLANG_ROOT ?= ../sauce-os
SLANG_BUILD=${SLANG_ROOT}/build
SLANGC := $(SLANG_BUILD)/x86/apps/compiler.exe
AOC_LIB_SRCS=aoclib.slang
CFLAGS=-I${SLANG_FOLDER}/runtime
LDFLAGS ?= --dynamic-linker /lib64/ld-linux-x86-64.so.2

.PHONY: all format profile clean

all: ${BUILDDIR}/day01.exe ${BUILDDIR}/day02.exe ${BUILDDIR}/day03.exe ${BUILDDIR}/day04.exe ${BUILDDIR}/day05.exe \
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
  ${BUILDDIR}/day17.exe

${BUILDDIR}/day%.exe: ${BUILDDIR}/day%.o ${SLANG_BUILD}/slangrt_main.o ${SLANG_BUILD}/x86/libbase.so ${SLANG_BUILD}/x86/libslangrt.so ${BUILDDIR}/libaoc.o
	ld ${LDFLAGS} -o $@ -L ${SLANG_BUILD}/x86 -rpath ${SLANG_BUILD}/x86 /usr/lib/crt1.o /usr/lib/crti.o $< ${SLANG_BUILD}/slangrt_main.o ${BUILDDIR}/libaoc.o -lbase -lslangrt -lm -lc /usr/lib/crtn.o

${BUILDDIR}/day%.o: ./%/main.slang ${SLANG_BUILD}/x86/libbase.json ${BUILDDIR}/libaoc.json | ${BUILDDIR}
	${SLANGC} -Wunused --backend-x86 --add-import ${SLANG_BUILD}/x86/libbase.json --add-import ${BUILDDIR}/libaoc.json -o $@ $<

${BUILDDIR}/libaoc.o ${BUILDDIR}/libaoc.json: ${AOC_LIB_SRCS} ${SLANG_BUILD}/x86/libbase.json | ${BUILDDIR}
	${SLANGC} --backend-x86 --add-import ${SLANG_BUILD}/x86/libbase.json --gen-export ${BUILDDIR}/libaoc.json -o ${BUILDDIR}/libaoc.o ${AOC_LIB_SRCS}

${BUILDDIR}:
	mkdir -p ${BUILDDIR}

format:
	$(SLANG_BUILD)/x86/apps/format.exe --in-place **/*.slang

profile: ${BUILDDIR}/day17.exe
	valgrind --tool=callgrind --callgrind-out-file=${BUILDDIR}/callgrind.out ./${BUILDDIR}/day17.exe
	kcachegrind ${BUILDDIR}/callgrind.out

clean:
	rm -rf ${BUILDDIR}
