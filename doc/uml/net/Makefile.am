if ENABLE_UML

uml_UML = \
	enums.uml \
	factory.uml \
	rest-service.uml \
	zmq-client.uml \
	zmq-service.uml \
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

