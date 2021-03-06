.PHONY: redo clean debug all

ARG := 

CXX ?= clang++
CFLAGS := -Wall -Wextra -Wpedantic -fshort-enums -ffast-math -Wno-unused -finline-functions -fno-strict-aliasing -funroll-loops -ftree-vectorize -march=native -mtune=native -Wwrite-strings -Wno-builtin-macro-redefined  -Winline -pedantic-errors -Wcast-function-type -fno-exceptions	

SRC = $(wildcard src/*.cpp)
SRC += $(wildcard src/**/*.cpp)
SRC_C_H = src/**/*.cpp src/**/*.hpp


ANALYZE := 
ifeq ($(CXX), gcc)
ANALYZE = -fanalyzer
CFLAGS += -Wcast-align=strict
else ifeq ($(CXX), clang++)
ANALYZE = -Xanalyzer
CFLAGS += -Wcast-align
else
CFLAGS += 
endif


STRICT  = -Werror
CSTD = -std=c++17
CSTD_LINT = --std=c++17
DEBUG  = -g -DDEBUG
BIN  = ./build/rotate


all: format
	@cmake --build build


redo: clean gen build all
	@echo done

gen:
	@cmake -S . -B build -G Ninja

scan:
	@rm -rf output
	@scan-build -o ./output $(CXX) $(SRC) -o $(BIN) $(CFLAGS) $(DEBUG) $(CSTD) $(LIB)
	@scan-view ./output/*

fast:
	$(CXX) $(SRC) -o $(BIN) $(CFLAGS) $(ANALYZE) $(CSTD) $(LIB) -Ofast

afl:
	afl-$(CXX) $(SRC) -o $(BIN) $(CFLAGS) $(DEBUG) $(CSTD) $(LIB)

debug:
	$(CXX) $(SRC) -o $(BIN) $(CFLAGS) $(ANALYZE) $(DEBUG) $(CSTD) $(LIB) -fsanitize=undefined

hidden_debug:
	@$(CXX) $(SRC) -o $(BIN) $(CFLAGS) $(ANALYZE) $(DEBUG) $(CSTD) $(LIB) -fsanitize=undefined



clean:
	@rm -rf output*
	@rm -rf build/


memcheck: debug
	@valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes -s $(BIN) ./main.vr

lint:
	@cppcheck  $(SRC_C_H) $(CSTD_LINT) --enable=all --check-config --quiet

format:
	@clang-format -i src/*/**.cpp src/*/**.hpp 

release:
	$(CXX) $(SRC) -O2 -Ofast -o $(BIN) $(CFLAGS) $(CSTD) $(LIB) $(ANALYZE) -Werror $(STRICT)
