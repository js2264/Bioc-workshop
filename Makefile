.PHONY: run_local build
IPYNB = $(shell find Exercices/ -type f -name '*.ipynb')  
HTML_NB= $(IPYNB:%.ipynb=%.html)

build: $(HTML_NB)
	echo $(HTML_NB)
	Rscript -e "blogdown::build_dir('content/')"
	Rscript -e "blogdown::build_dir('static/')"
	Rscript -e "blogdown::build_site()"

%.html: %.ipynb
	jupyter-nbconvert --to html $<;

run_local:
	Rscript -e "blogdown::hugo_server(host='127.0.0.1', port = 4321)"
