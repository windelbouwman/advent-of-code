
BUILDDIR=build
SLANG_FOLDER=../../sauce-os
SLANGC := $(SLANG_FOLDER)/build/compiler5
BASE_LIB_SRCS := $(wildcard ${SLANG_FOLDER}/Libs/base/*.slang)
BASE_LIB_SRCS += ${SLANG_FOLDER}/runtime/std.slang
REGEX_LIB_SRCS := $(wildcard ${SLANG_FOLDER}/Libs/regex/*.slang)
AOC_LIB_SRCS=aoclib.slang
CFLAGS=-I${SLANG_FOLDER}/runtime

all: ${BUILDDIR}/day01.exe \
	${BUILDDIR}/day02.exe \
	${BUILDDIR}/day03.exe \
	${BUILDDIR}/day05.exe

${BUILDDIR}/day%.exe: ${BUILDDIR}/day%.o ${BUILDDIR}/slangrt.o ${BUILDDIR}/slangrt_mm.o ${BUILDDIR}/aoclib-c.o ${BUILDDIR}/libbase.o ${BUILDDIR}/libregex.o ${BUILDDIR}/libaoc.o
	gcc -o $@ $< ${BUILDDIR}/slangrt.o ${BUILDDIR}/slangrt_mm.o ${BUILDDIR}/aoclib-c.o ${BUILDDIR}/libbase.o ${BUILDDIR}/libregex.o  ${BUILDDIR}/libaoc.o -lm

${BUILDDIR}/day%.o: ${BUILDDIR}/day%.c
	gcc ${CFLAGS} -c -o $@ $<

${BUILDDIR}/lib%.o: ${BUILDDIR}/lib%.c
	gcc ${CFLAGS} -c -o $@ $<

${BUILDDIR}/slangrt.o: ${SLANG_FOLDER}/runtime/slangrt.c | ${BUILDDIR}
	gcc ${CFLAGS} -c -o $@ $<

${BUILDDIR}/slangrt_mm.o: ${SLANG_FOLDER}/runtime/slangrt_mm.c | ${BUILDDIR}
	gcc ${CFLAGS} -c -o $@ $<

${BUILDDIR}/day%.c: ./%/main.slang ${BUILDDIR}/libbase.json ${BUILDDIR}/libregex.json ${BUILDDIR}/libaoc.json | ${BUILDDIR}
	$(SLANGC) --backend-c --add-import ${BUILDDIR}/libbase.json --add-import ${BUILDDIR}/libregex.json --add-import ${BUILDDIR}/libaoc.json -o $@ $<

${BUILDDIR}/aoclib-c.o: aoclib-c.c | ${BUILDDIR}
	gcc ${CFLAGS} -c -o $@ $<

${BUILDDIR}/libaoc.c ${BUILDDIR}/libaoc.json: ${AOC_LIB_SRCS} ${BUILDDIR}/libbase.json | ${BUILDDIR}
	$(SLANGC) --backend-c --add-import ${BUILDDIR}/libbase.json --gen-export ${BUILDDIR}/libaoc.json -o ${BUILDDIR}/libaoc.c ${AOC_LIB_SRCS}

${BUILDDIR}/libregex.c ${BUILDDIR}/libregex.json: ${REGEX_LIB_SRCS} ${BUILDDIR}/libbase.json ${SLANGC_DEPS} | ${BUILDDIR}
	$(SLANGC) --backend-c --gen-export ${BUILDDIR}/libregex.json -o ${BUILDDIR}/libregex.c --add-import ${BUILDDIR}/libbase.json ${REGEX_LIB_SRCS}

${BUILDDIR}/libbase.c ${BUILDDIR}/libbase.json: ${BASE_LIB_SRCS} | ${BUILDDIR}
	$(SLANGC) --backend-c --gen-export ${BUILDDIR}/libbase.json -o ${BUILDDIR}/libbase.c ${BASE_LIB_SRCS}

${BUILDDIR}:
	mkdir -p ${BUILDDIR}
