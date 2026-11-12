NAME=infufrgs

# Run inside `nix develop` so that TEXINPUTS points to infufrgs.cls.
all: $(NAME).pdf

%.tex: %.org setup.el export.el
	emacs --batch --load export.el

%.pdf: %.tex
	latexmk -pdf -interaction=nonstopmode $<

nix:
	nix build .

clean:
	latexmk -c $(NAME).tex

distclean: clean
	rm -f $(NAME).tex $(NAME).pdf refs.bib

.PHONY: all nix clean distclean
