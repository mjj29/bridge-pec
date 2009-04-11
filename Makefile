# dummy
CARD?=level4_7boardrounds.pdf

all: systemnotes.pdf systemnotes-book.pdf

clean:
	rm -f *.aux *.log systemnotes.pdf blank.pdf systemnotes-book.pdf temp* log card.pdf

systemnotes.pdf: systemnotes.tex
	pdflatex $<

blank.pdf: blank.tex
	pdflatex $<

systemnotes-book.pdf: systemnotes.pdf ${CARD} blank.pdf
	pdfnup --paper a4paper --nup 1x1 --noautoscale true --scale 1.4 --tidy false --outfile card.pdf ${CARD}
	pdftk S=$< C=card.pdf cat C4 C1-3 S1-end output temp.pdf
	pdf2ps temp.pdf temp.ps
	< temp.ps psbook >/dev/null 2>log
	export PAGES="$$(echo `cat log` | sed 's/\] \[/ /g' | sed 's/^.//;s/].*$$//;s/[0-9]\+/A&/g;s/\*/B1/g')"; \
			pdftk B=blank.pdf A=temp.pdf cat $${PAGES} output temp2.pdf; \
			echo $$PAGES
	pdfnup --nup 2x1 --outfile $@ temp2.pdf 
	rm -f temp.ps temp2.pdf temp2-2x1.pdf temp.pdf log card.pdf

