V ?= 0

SRC_DIR = src
BUILD_DIR = build
DIST_DIR = dist
ASSETS_DIR = assets

PREFIX = .

JS_ENGINE ?= `which node nodejs`
COMPILER = ${JS_ENGINE} ${BUILD_DIR}/uglify.js --unsafe
POST_COMPILER = ${JS_ENGINE} ${BUILD_DIR}/post-compile.js

JRC_ORIGIN = ${SRC_DIR}/jquery.jright.js
JRC = ${DIST_DIR}/jright/jquery.jright.js
JRC_MIN = ${DIST_DIR}/jright/jquery.jright.min.js

VERSION = $(shell cat version.txt)
VER = sed "s/@VERSION/${VERSION}/"

DATE=$(shell git log -1 --pretty=format:%ad)

all: jright min
	@@echo "=== jright build complete. ==="

jright:
	@@ \
  echo "* Compiling stylesheets..."; \
  compass compile -s compressed --css-dir ${DIST_DIR}/jright; \
  echo "* Copying jright..."; \
  cp ${JRC_ORIGIN} ${DIST_DIR}/jright; \
  echo "* Copying assets files..."; \
  cp ${ASSETS_DIR}/demo.html ${DIST_DIR}; \
  cp ${ASSETS_DIR}/jquery.client.js ${DIST_DIR}/jright; \
  cp ${ASSETS_DIR}/selectivizr.js ${DIST_DIR}/jright;

min:
	@@if test ! -z ${JS_ENGINE}; then \
		echo "* Minifying jright" ${JRC_MIN}; \
		${COMPILER} ${JRC} > ${JRC_MIN}.tmp; \
		${POST_COMPILER} ${JRC_MIN}.tmp > ${JRC_MIN}; \
		rm -f ${JRC_MIN}.tmp; \
	else \
		echo "You must have NodeJS installed in order to minify jright."; \
	fi
