# Local LaTeX compilation — preview before pushing
# Requires: xelatex + latexmk  (brew install mactex or mactex-no-gui)

.PHONY: build open clean watch

# Compile and open the PDF
build:
	latexmk -xelatex -interaction=nonstopmode -halt-on-error resume.tex

open: build
	open resume.pdf

# Watch for changes and recompile automatically
watch:
	latexmk -xelatex -interaction=nonstopmode -pvc resume.tex

clean:
	latexmk -C
