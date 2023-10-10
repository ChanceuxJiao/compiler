TARGET = bonus1

INPUT_FILE = input.txt

OUTPUT_FILE = output.txt

all: $(TARGET)

$(TARGET): bonus1.tab.c
	gcc $< -o $@

bonus1.tab.c: bonus1.y
	yacc $< -o $@

run: $(TARGET)
	./$(TARGET) < $(INPUT_FILE) > $(OUTPUT_FILE)

clean:
	rm -f $(TARGET) bonus1.tab.c $(OUTPUT_FILE)

.PHONY: all run clean
