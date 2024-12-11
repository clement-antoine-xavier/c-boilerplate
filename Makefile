NAME = c-boilerplate

CC = gcc
CFLAGS = -I$(HEADERS) -Wall -Wextra -Werror -O3 -fstack-protector-strong -D_FORTIFY_SOURCE=2 \
	-Wformat=2 -Wshadow -Wconversion -Wnull-dereference -Wimplicit-fallthrough -pedantic \
	-fPIE -pie -march=native -flto -fvisibility=hidden -fsanitize=address,undefined,leak \
	-fstack-protector-all -pg
LDFLAGS = -Wl,-z,relro,-z,now -flto -fsanitize=address,undefined,leak

SOURCES_DIR = ./sources
OBJ_DIR = ./objects
HEADERS = ./headers
BINARY_DIR = .

SOURCES = $(shell find $(SOURCES_DIR) -type f -regex ".*\.c")
OBJECTS = $(SOURCES:$(SOURCES_DIR)/%.c=$(OBJ_DIR)/%.o)
COVERAGE = $(SOURCES:$(SOURCES_DIR)/%.c=$(OBJ_DIR)/%.gcda) \
	$(SOURCES:$(SOURCES_DIR)/%.c=$(OBJ_DIR)/%.gcno)
INCLUDE = $(wildcard $(HEADERS)/*.h)
BIN = $(BINARY_DIR)/$(NAME)

MAIN_SOURCES = ./main.c

TESTS_SOURCES_DIR = ./tests
TESTS_OBJ_DIR = ./obj/tests

TESTS_SOURCES = $(shell find $(TESTS_SOURCES_DIR) -type f -regex ".*\.c")
TESTS_OBJ = $(TESTS_SOURCES:$(TESTS_SOURCES_DIR)/%.c=$(TESTS_OBJ_DIR)/%.o)
TESTS_COVERAGE = $(TESTS_SOURCES:$(TESTS_SOURCES_DIR)/%.c=$(TESTS_OBJ_DIR)/%.gcda) \
	$(TESTS_SOURCES:$(TESTS_SOURCES_DIR)/%.c=$(TESTS_OBJ_DIR)/%.gcno)
TESTS_BIN = $(BINARY_DIR)/unit_tests

all: $(BIN)
	@echo "Building $(NAME)"

$(BIN): $(OBJECTS) $(MAIN_SOURCES)
	@echo "Linking $@"
	@$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

$(OBJ_DIR)/%.o: $(SOURCES_DIR)/%.c $(INCLUDE)
	@mkdir -p $(@D)
	@echo "Compiling $< to $@"
	@$(CC) $(CFLAGS) -MMD -MP -c -o $@ $<

clean:
	@echo "Cleaning $(NAME)"
	@rm -f $(OBJECTS)
	@rm -f $(COVERAGE)
	@rm -f $(TESTS_OBJ)
	@rm -f $(TESTS_COVERAGE)

fclean: clean
	@echo "Removing $(NAME)"
	@rm -f $(BIN)
	@rm -f $(TESTS_BIN)

re: fclean all

debug: CFLAGS += -g3 -ggdb
debug: LDFLAGS += -fsanitize=address,undefined
debug: re

tests_run: $(TESTS_BIN)
	@echo "Running tests"
	@./$(TESTS_BIN)

$(TESTS_BIN): CFLAGS += --coverage
$(TESTS_BIN): LDFLAGS += -lcriterion
$(TESTS_BIN): clean $(OBJECTS) $(TESTS_OBJ)
	@echo "Linking $@"
	@$(CC) $(CFLAGS) -o $@ $(OBJECTS) $(TESTS_OBJ) $(LDFLAGS)

$(TESTS_OBJ_DIR)/%.o: $(TESTS_SOURCES_DIR)/%.c $(INCLUDE)
	@mkdir -p $(@D)
	@echo "Compiling $< to $@"
	@$(CC) $(CFLAGS) -MMD -MP -c -o $@ $<

coding-style: fclean
	@echo "Checking coding style"
	@rm -f ./coding-style-reports.log
	@./coding-style.sh . .
	@cat ./coding-style-reports.log

coverage: tests_run
	@lcov --capture --directory . --output-file coverage.info
	@genhtml coverage.info --output-directory coverage_report
	@echo "Code coverage report is available at coverage_report/index.html"

static-analysis:
	@echo "Running static analysis"
	@clang-tidy $(SOURCES) -- -I$(HEADERS)

.PHONY: all clean fclean re debug coding-style coverage static-analysis
