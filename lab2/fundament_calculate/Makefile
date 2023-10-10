TARGET = fundament

INPUT_FILE = input.txt

OUTPUT_FILE = output.txt

all: $(TARGET)

$(TARGET): fundament.tab.c
	gcc $< -o $@

fundament.tab.c: fundament.y
	yacc $< -o $@

run: $(TARGET)
	./$(TARGET) < $(INPUT_FILE) > $(OUTPUT_FILE)

clean:
	rm -f $(TARGET) fundament.tab.c $(OUTPUT_FILE)

.PHONY: all run clean
