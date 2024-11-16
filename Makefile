# dwm - dynamic window manager
# See LICENSE file for copyright and license details.

include config.mk

BUILD_DIR := build
SRCS := $(shell find . -name '*.c')
OBJS := $(subst ./, $(BUILD_DIR)/, $(SRCS:.c=.o))

all: options $(BUILD_DIR)/dwm

CFLAGS := ${CFLAGS} -MMD

options:
	@echo dwm build options:
	@echo "BUILD_DIR: ${BUILD_DIR}"
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

$(BUILD_DIR):
	mkdir -p ${BUILD_DIR}

$(BUILD_DIR)/%.o: %.c | $(BUILD_DIR)
	${CC} -c -o $@ $< $(CFLAGS)

$(BUILD_DIR)/dwm: ${OBJS}
	${CC} -o $@ ${OBJS} ${LDFLAGS}

clean:
	rm -f dwm ${OBJ} dwm-${VERSION}.tar.gz
	rm -rf ${BUILD_DIR}

dist: clean
	mkdir -p dwm-${VERSION}
	cp -R LICENSE Makefile README config.def.h config.mk\
		dwm.1 drw.h util.h ${SRC} dwm.png transient.c dwm-${VERSION}
	tar -cf dwm-${VERSION}.tar dwm-${VERSION}
	gzip dwm-${VERSION}.tar
	rm -rf dwm-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f ${BUILD_DIR}/dwm ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/dwm
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < dwm.1 > ${DESTDIR}${MANPREFIX}/man1/dwm.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/dwm.1
	mkdir -p ${DESTDIR}/usr/share/xsessions
	cp -f dwm.desktop ${DESTDIR}/usr/share/xsessions

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/dwm
	rm -f ${DESTDIR}${MANPREFIX}/man1/dwm.1
	rm -f /usr/share/xsessions/dwm.desktop

-include $(BUILD_DIR)/*.d

.PHONY: all options clean dist install uninstall
