PARSER=jenkins_parser
BISON=bison
FLEX=flex
CC=gcc

all: $(PARSER)

jenkins.tab.c jenkins.tab.h: jenkins.y
	$(BISON) -d -o jenkins.tab.c jenkins.y

lex.yy.c: jenkins.l jenkins.tab.h
	$(FLEX) -o lex.yy.c jenkins.l

$(PARSER): jenkins.tab.c lex.yy.c
	$(CC) -o $(PARSER) jenkins.tab.c lex.yy.c

clean:
	rm -f $(PARSER) jenkins.tab.c jenkins.tab.h lex.yy.c

test: all
	@echo "Running parser on tests/**/*.jenkinsfile"
	@find tests -type f -name "*.jenkinsfile" | while read -r f; do \
	  echo "--- $$f ---"; \
	  ./$(PARSER) $$f || true; \
	done

test-all: test
