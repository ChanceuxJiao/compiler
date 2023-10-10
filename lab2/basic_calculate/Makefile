TARGET = basic

INPUT_FILE = input.txt

OUTPUT_FILE = output.txt

all: $(TARGET)

$(TARGET): basic.tab.c
	gcc $< -o $@

basic.tab.c: basic.y
	yacc $< -o $@

run: $(TARGET)
	./$(TARGET) < $(INPUT_FILE) > $(OUTPUT_FILE)

clean:
	rm -f $(TARGET) basic.tab.c $(OUTPUT_FILE)

.PHONY: all run clean
