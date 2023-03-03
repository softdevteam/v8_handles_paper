.SUFFIXES: .ltx .pdf .svg

.svg.pdf:
	inkscape --export-filename=$@ $<

DIAGRAMS =

all: v8_handles_paper.pdf

clean:
	rm -rf ${DIAGRAMS} ${DIAGRAMS:S/.pdf/.eps/}
	rm -rf v8_handles_paper.aux v8_handles_paper.bbl v8_handles_paper.blg v8_handles_paper.dvi v8_handles_paper.log v8_handles_paper.ps v8_handles_paper.pdf v8_handles_paper.toc v8_handles_paper.out v8_handles_paper.snm v8_handles_paper.nav v8_handles_paper.vrb texput.log

v8_handles_paper.pdf: bib.bib v8_handles_paper.ltx v8_handles_paper_preamble.fmt softdev.sty ${DIAGRAMS}
	pdflatex v8_handles_paper.ltx
	bibtex v8_handles_paper
	pdflatex v8_handles_paper.ltx
	pdflatex v8_handles_paper.ltx

v8_handles_paper_preamble.fmt: v8_handles_paper_preamble.ltx softdev.sty table_min.tex table_no_stack_compact.tex experimentstats.tex
	set -e; \
	  tmpltx=`mktemp`; \
	  cat ${@:fmt=ltx} > $${tmpltx}; \
	  grep -v "%&${@:_preamble.fmt=}" ${@:_preamble.fmt=.ltx} >> $${tmpltx}; \
	  pdftex -ini -jobname="${@:.fmt=}" "&pdflatex" mylatexformat.ltx $${tmpltx}; \
	  rm $${tmpltx}


softdevbib-update: softdevbib
	cd softdevbib && git pull

bib.bib: softdevbib/softdev.bib local.bib
	softdevbib/bin/prebib -x month softdevbib/softdev.bib > bib.bib
	softdevbib/bin/prebib -x month local.bib >> bib.bib

softdevbib/softdev.bib:
	git submodule init
	git submodule update
