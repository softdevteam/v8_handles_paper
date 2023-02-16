.SUFFIXES: .ltx .pdf .svg

.svg.pdf:
	inkscape --export-filename=$@ $<

DIAGRAMS =

all: v8_handles_paper.pdf

clean:
	rm -rf ${DIAGRAMS} ${DIAGRAMS:S/.pdf/.eps/}
	rm -rf v8_handles_paper.aux v8_handles_paper.bbl v8_handles_paper.blg v8_handles_paper.dvi v8_handles_paper.log v8_handles_paper.ps v8_handles_paper.pdf v8_handles_paper.toc v8_handles_paper.out v8_handles_paper.snm v8_handles_paper.nav v8_handles_paper.vrb texput.log

v8_handles_paper.pdf: bib.bib v8_handles_paper.ltx v8_handles_paper_preamble.fmt ${DIAGRAMS}
	pdflatex v8_handles_paper.ltx
	bibtex v8_handles_paper
	pdflatex v8_handles_paper.ltx
	pdflatex v8_handles_paper.ltx

v8_handles_paper_preamble.fmt: v8_handles_paper_preamble.ltx
	set -e; \
	  tmpltx=`mktemp`; \
	  cat ${@:fmt=ltx} > $${tmpltx}; \
	  grep -v "%&${@:_preamble.fmt=}" ${@:_preamble.fmt=.ltx} >> $${tmpltx}; \
	  pdftex -ini -jobname="${@:.fmt=}" "&pdflatex" mylatexformat.ltx $${tmpltx}; \
	  rm $${tmpltx}

bib.bib: softdevbib/softdev.bib
	softdevbib/bin/prebib softdevbib/softdev.bib > bib.bib

softdevbib-update: softdevbib
	cd softdevbib && git pull

softdevbib/softdev.bib: softdevbib

softdevbib:
	git clone https://github.com/softdevteam/softdevbib.git
