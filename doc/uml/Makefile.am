SUBDIRS = cli core daq log net ui

if ENABLE_UML

uml_UML = \
	dcs-activity.uml \
	dcs-class.uml \
	dcs-component.uml \
	dcs-sequence.uml \
	dcs-state.uml \
	$(NULL)

uml_PNG = \
	$(uml_UML:%.uml=%.png)

uml_PDF = \
	$(uml_UML:%.uml=%.pdf)

all: $(uml_PNG) # $(uml_PDF)

clean:
	-test -z "$(CLEAN_FILES)" || rm -f $(CLEAN_FILES)

%.png: %.uml
	$(PLANTUML) $<

%.pdf: %.uml
	$(PLANTUML) -tpdf $<

CLEAN_FILES = \
	$(uml_PNG) \
	$(uml_PDF) \
	$(NULL)

GITIGNOREFILES = \
	$(uml_PNG) \
	$(uml_PDF) \
	$(NULL)

endif

-include $(top_srcdir)/git.mk
