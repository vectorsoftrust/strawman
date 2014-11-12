DOC=VectorsOfTrust

## Change nothing below this line unless you know what you're doing

VER=00
TEXT=$(DOC)-$(VER).txt
HTML=$(DOC)-$(VER).html
XML=$(DOC).xml

all: $(TEXT) $(HTML) 

$(XML): $(DOC).md
	kramdown-rfc2629 $< > $@

$(TEXT): $(XML)
	xml2rfc $< -o $@

$(HTML): $(DOC).xml
	xml2rfc $< --html -o $@

clean:
	rm -f *.pdf *.xml *.html *.txt *~
