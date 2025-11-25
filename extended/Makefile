BISON_OUT=extended.tab
LEX_OUT=lex_extended.yy.c
PARSER=extended_parser
BISON=bison
FLEX=flex
CC=gcc

all: $(PARSER)


$(BISON_OUT).c $(BISON_OUT).h: extended.y
	$(BISON) -d -o $(BISON_OUT).c extended.y

$(LEX_OUT): extended.l $(BISON_OUT).h
	$(FLEX) -o $(LEX_OUT) extended.l

$(PARSER): $(BISON_OUT).c $(LEX_OUT)
	$(CC) -o $(PARSER) $(BISON_OUT).c $(LEX_OUT)

clean:
	rm -f $(PARSER) $(BISON_OUT).c $(BISON_OUT).h $(LEX_OUT)


test: all
	@echo "Running extended parser on tests/**/*.jenkinsfile"
	@find ../tests/ -type f -name "*.jenkinsfile" | while read -r f; do \
	  echo "--- $$f ---"; \
	  ./$(PARSER) $$f || true; \
	done

