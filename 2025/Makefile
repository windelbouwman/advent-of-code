
BUILDDIR=build
SLANG_ROOT ?= ../sauce-os
SLANG_BUILD=${SLANG_ROOT}/build
SLANGC := $(SLANG_BUILD)/x86/apps/compiler.exe
AOC_LIB_SRCS=aoclib.slang
LDFLAGS ?= --dynamic-linker /lib64/ld-linux-x86-64.so.2

.PHONY: all
all: ${BUILDDIR}/day01.exe \
	${BUILDDIR}/day02.exe \
	${BUILDDIR}/day03.exe \
	${BUILDDIR}/day04.exe \
	${BUILDDIR}/day05.exe \
	${BUILDDIR}/day06.exe \
	${BUILDDIR}/day07.exe \
	${BUILDDIR}/day09.exe

.PHONY: test
test: all
	pytest -v test_days.py

${BUILDDIR}/day%.exe: ${BUILDDIR}/day%.o ${SLANG_BUILD}/x86/libslangrt.so ${SLANG_BUILD}/slangrt_main.o ${SLANG_BUILD}/x86/libbase.so ${BUILDDIR}/libaoc.o
	ld ${LDFLAGS} -o $@ -L ${SLANG_BUILD}/x86 -rpath ${SLANG_BUILD}/x86 /usr/lib/crt1.o /usr/lib/crti.o $< ${SLANG_BUILD}/slangrt_main.o ${BUILDDIR}/libaoc.o -lbase -lslangrt -lm -lc /usr/lib/crtn.o

${BUILDDIR}/day%.o: ./%/main.slang ${SLANG_BUILD}/x86/libbase.json ${BUILDDIR}/libaoc.json | ${BUILDDIR}
	$(SLANGC) --backend-x86 --add-import ${SLANG_BUILD}/x86/libbase.json --add-import ${BUILDDIR}/libaoc.json -o $@ $<

${BUILDDIR}/libaoc.o ${BUILDDIR}/libaoc.json: ${AOC_LIB_SRCS} ${SLANG_BUILD}/x86/libbase.json | ${BUILDDIR}
	$(SLANGC) --backend-x86 --add-import ${SLANG_BUILD}/x86/libbase.json --gen-export ${BUILDDIR}/libaoc.json -o ${BUILDDIR}/libaoc.o ${AOC_LIB_SRCS}

${BUILDDIR}:
	mkdir -p ${BUILDDIR}

.PHONY: clean
clean:
	rm -rf ${BUILDDIR}
