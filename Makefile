CC=gcc
EMACS=emacs
BATCH_EMACS=$(EMACS) --batch -Q -l init-new.el iKNOW2012-orgmode-demo.org

all: iKNOW2012-orgmode-demo.pdf

## some minor things have to be improved in the Org-mode LaTeX exporter
## meanwhile: as a workaround, these things will be removed using grep and sed:
iKNOW2012-orgmode-demo.tex: iKNOW2012-orgmode-demo.org
	$(BATCH_EMACS) -f org-e-latex-export-to-latex
	egrep -v "(#\+name: author-list|#\+header: |#\+name: ACM-categories|#\+RESULTS: |\\terms\{\})" iKNOW2012-orgmode-demo.tex > iKNOW2012-orgmode-demo.temp1
	sed 's/\\titlenote{}//' iKNOW2012-orgmode-demo.temp1 > iKNOW2012-orgmode-demo.temp2
	-rm iKNOW2012-orgmode-demo.tex
	-mv iKNOW2012-orgmode-demo.temp2 iKNOW2012-orgmode-demo.tex
	-rm iKNOW2012-orgmode-demo.temp*

iKNOW2012-orgmode-demo.pdf: iKNOW2012-orgmode-demo.tex
	rm -f iKNOW2012-orgmode-demo.aux
	if pdflatex iKNOW2012-orgmode-demo.tex </dev/null; then \
		true; \
	else \
		stat=$$?; touch iKNOW2012-orgmode-demo.pdf; exit $$stat; \
	fi
	bibtex iKNOW2012-orgmode-demo
	while grep "Rerun to get" iKNOW2012-orgmode-demo.log; do \
		if pdflatex iKNOW2012-orgmode-demo.tex </dev/null; then \
			true; \
		else \
			stat=$$?; touch iKNOW2012-orgmode-demo.pdf; exit $$stat; \
		fi; \
	done

iKNOW2012-orgmode-demo.ps: iKNOW2012-orgmode-demo.pdf
	pdf2ps iKNOW2012-orgmode-demo.pdf

clean:
	rm -f *.temp *.temp1 *.temp2 *.aux *.log  *.dvi *.blg *.bbl *.toc *.tex *~ *.out *.xml *.lot *.lof
