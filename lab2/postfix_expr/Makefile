TARGET = advance1

INPUT_FILE = input.txt

OUTPUT_FILE = output.txt

all: $(TARGET)

$(TARGET): advance1.tab.c
	gcc $< -o $@

advance1.tab.c: advance1.y
	yacc $< -o $@

run: $(TARGET)
	./$(TARGET) < $(INPUT_FILE) > $(OUTPUT_FILE)

clean:
	rm -f $(TARGET) advance1.tab.c $(OUTPUT_FILE)

.PHONY: all run clean
