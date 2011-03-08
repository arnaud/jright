V ?= 0

JR_VER = $(shell cat version.txt)

SRC_DIR = src
ASSETS_DIR = assets
BUILD_DIR = build

PREFIX = .
DIST_DIR = ${PREFIX}/dist/jright-${JR_VER}

JS_ENGINE ?= `which node nodejs`
COMPILER = ${JS_ENGINE} ${BUILD_DIR}/uglify.js --unsafe
POST_COMPILER = ${JS_ENGINE} ${BUILD_DIR}/post-compile.js

MODULES = ${JR_ORIGIN}

BASE_FILES = ${SRC_DIR}/core.js

MODULES = ${SRC_DIR}/copyright.js\
	${BASE_FILES}

JR = ${DIST_DIR}/jquery.jright.js
JR_MIN = ${DIST_DIR}/jquery.jright.min.js

VER = sed "s/@VERSION/${JR_VER}/"

DATE=$(shell git log -1 --pretty=format:%ad)

all: clean init assets styles jright min
	@@echo "=== jright build complete. ==="

${DIST_DIR}:
	@@mkdir -p ${DIST_DIR}; \
	mkdir -p ${DIST_DIR}/js

init: ${DIST_DIR}

jright: init ${JR}

assets: init
	@@echo "* Copying assets files..."; \
	cp ${ASSETS_DIR}/demo.html ${DIST_DIR}; \
	cp ${ASSETS_DIR}/jquery.client.js ${DIST_DIR}/js; \
	cp ${ASSETS_DIR}/selectivizr.js ${DIST_DIR}/js; \
	cp README.textile ${DIST_DIR};

styles: init
	@@echo "* Compiling stylesheets..."; \
	compass compile -s compressed --css-dir ${DIST_DIR} --images-dir src/styles/images;

${JR}: ${MODULES} | ${DIST_DIR}
	@@echo "* Building" ${JR}
	@@cat ${MODULES} | \
		sed 's/.function.$..{//' | \
		sed 's/}..jQuery.;//' | \
		sed 's/@DATE/'"${DATE}"'/' | \
		${VER} > ${JR};

min: ${JR_MIN}

${JR_MIN}: jright
	@@if test ! -z ${JS_ENGINE}; then \
		echo "* Minifying jright" ${JR_MIN}; \
		${COMPILER} ${JR} > ${JR_MIN}.tmp; \
		${POST_COMPILER} ${JR_MIN}.tmp > ${JR_MIN}; \
		rm -f ${JR_MIN}.tmp; \
	else \
		echo "You must have NodeJS installed in order to minify jright."; \
	fi

clean:
	@@echo "Removing Distribution directory:" ${DIST_DIR}
	@@rm -rf ${DIST_DIR}

.PHONY: all init jright min clean
