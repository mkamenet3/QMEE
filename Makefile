# QMEE
# https://mac-theobio.github.io/QMEE/index.html
# https://docs.google.com/spreadsheets/d/1J1Zus295rPJADVXIt6GwomSxisgDurhjzskhUtsMbr4/edit#gid=2011507906

### Hooks for the editor to set the default target
current: target

target pngtarget pdftarget vtarget acrtarget: pages/index.html 

##################################################################

# make files

Sources = Makefile .gitignore README.md stuff.mk LICENSE.md notes.txt TODO.md
Sources += $(wildcard *.local)

include stuff.mk
-include $(ms)/git.def
-include $(ms)/perl.def
-include local.mk

##################################################################

Sources += $(wildcard *.Rmd *.rmd)

intro_Lecture_notes.html: intro_Lecture_notes.rmd
	echo 'rmarkdown::render("intro_Lecture_notes.rmd")' | R --vanilla

intro_Lecture_notes.io.html: intro_Lecture_notes.rmd
	echo 'rmarkdown::render("intro_Lecture_notes.rmd",output_format="ioslides_presentation", output_file="$@")' | R --vanilla


##################################################################

## Scraping

intro_%.mediawiki:
	wget -O $@ "http://lalashan.mcmaster.ca/theobio/bio_708/index.php?title=Introduction_to_R/$*&action=raw"

intro_Lecture_notes.mediawiki:

%.mediawiki: 
	wget -O $@ "http://lalashan.mcmaster.ca/theobio/bio_708/index.php?title=$*&action=raw"

Data_management.mw.md:
Visualization.mw.md:

Evolutionary_analysis.mediawiki:

##################################################################

## Converting
%.mw: %.mediawiki
	pandoc -f mediawiki -t markdown -o $@ $<

Sources += $(wildcard *.pl)
Statistical_philosophy.new: Statistical_philosophy.mw mdtrim.pl
%.new: %.mw mdtrim.pl
	$(PUSH)
	cp -n $@ $*.md

Data_management.tmk: Data_management.md tmk.pl
%.tmk: %.md tmk.pl
	$(PUSH)

%.rmk:
	$(RM) $*
	$(MAKE) $*

# Introduction_to_R.md: Introduction_to_R.mw.md mdtrim.pl

######################################################################

## Editing pages

Sources += $(wildcard *.md)
pages/index.html: index.md

######################################################################

## Formatting

Sources += qmee.css header.html footer.html
mds = pandoc -s -S -c qmee.css -B header.html -A footer.html -o $@ $<
pages/%.html: %.md qmee.css header.html footer.html
	$(mds)

######################################################################

## Exporting

pages:
	git clone git@github.com:mac-theobio/QMEE.git $@
	cp local.mk pages
	cd pages && $(MAKE) gh-pages.branch

md = $(wildcard *.md)
pages = $(md:%.md=pages/%.html)
pages/%.css: %.css
	$(copy)

push_pages: pages/qmee.css $(pages)
	cd pages

push_site: pages/qmee.css $(pages)
	cd pages && $(MAKE) sync

check:
	@echo $(pages)

######################################################################

### Makestuff

## Change this name to download a new version of the makestuff directory
# Makefile: start.makestuff

-include $(ms)/git.mk
-include $(ms)/visual.mk
-include $(ms)/linkdirs.mk

# -include $(ms)/wrapR.mk
# -include $(ms)/oldlatex.mk
