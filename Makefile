#
# 'make' will build the system notes. Other notable targets:
#
# make (something).2up.pdf will 2-up (something).pdf for printing cards
#
# make systemnotes-book.pdf will create the booklet of the long match card and the system notes
#
# make CARD=(something).pdf systemnotes-book.pdf will use a different convention card to make the booklet
#
# make clean will tidy up
#

CARD?=level4.pdf

all: systemnotes.pdf openinglist.pdf prepareddefences.pdf

clean:
	rm -f *.lof *.out *.toc *.aux *.log systemnotes.pdf blank.pdf systemnotes-book.pdf temp* log card.pdf *.2up.pdf prepareddefences.pdf systemnotes-bookalt.pdf

openinglist.pdf: openinglist.tex
	pdflatex $<
	pdflatex $<

prepareddefences.pdf: prepareddefences.tex
	pdflatex $<
	pdflatex $<

systemnotes.pdf: systemnotes.tex
	pdflatex $<
	pdflatex $<

blank.pdf: blank.tex
	pdflatex $<

%.2up.pdf: %.pdf
	pdfnup  --nup 2x1 --outfile $@ $<

card.pdf: ${CARD}
	pdfnup --paper a4paper --nup 1x1 --noautoscale true --scale 1.4 --no-landscape --outfile $@ $<

openinglist-book.pdf: openinglist.pdf ${CARD} blank.pdf card.pdf
	pdftk S=$< C=card.pdf cat C4 C1-3 S1-end output temp.pdf
	pdf2ps temp.pdf temp.ps
	< temp.ps psbook >/dev/null 2>log
	export PAGES="$$(echo `cat log` | sed 's/\] \[/ /g' | sed 's/^.//;s/].*$$//;s/[0-9]\+/A&/g;s/\*/B1/g')"; \
			pdftk B=blank.pdf A=temp.pdf cat $${PAGES} output temp2.pdf; \
			echo $$PAGES
	pdfnup --nup 2x1 --outfile $@ temp2.pdf 
	rm -f temp.ps temp2.pdf temp2-2x1.pdf temp.pdf log card.pdf

systemnotes-book.pdf: systemnotes.pdf ${CARD} blank.pdf card.pdf
	pdftk S=$< C=card.pdf cat C4 C1-3 S1-end output temp.pdf
	pdf2ps temp.pdf temp.ps
	< temp.ps psbook >/dev/null 2>log
	export PAGES="$$(echo `cat log` | sed 's/\] \[/ /g' | sed 's/^.//;s/].*$$//;s/[0-9]\+/A&/g;s/\*/B1/g')"; \
			pdftk B=blank.pdf A=temp.pdf cat $${PAGES} output temp2.pdf; \
			echo $$PAGES
	pdfnup --nup 2x1 --outfile $@ temp2.pdf 
	rm -f temp.ps temp2.pdf temp2-2x1.pdf temp.pdf log card.pdf

systemnotes-bookalt.pdf: systemnotes.pdf ${CARD} blank.pdf
	pdfnup --paper a4paper --nup 1x1 --noautoscale true --scale 1.4 --outfile card.pdf ${CARD}
	pdftk S=$< C=card.pdf cat C8 C5-7 S1-end output temp.pdf
	pdf2ps temp.pdf temp.ps
	< temp.ps psbook >/dev/null 2>log
	export PAGES="$$(echo `cat log` | sed 's/\] \[/ /g' | sed 's/^.//;s/].*$$//;s/[0-9]\+/A&/g;s/\*/B1/g')"; \
			pdftk B=blank.pdf A=temp.pdf cat $${PAGES} output temp2.pdf; \
			echo $$PAGES
	pdfnup --nup 2x1 --outfile $@ temp2.pdf 
	rm -f temp.ps temp2.pdf temp2-2x1.pdf temp.pdf log card.pdf

