if ENABLE_UML

uml_UML = \
	application.uml \
	factory.uml \
	$(NULL)

uml_PNG = \
	$(uml_UML:%.uml=%.png)

all: $(uml_PNG)

clean:
	-test -z "$(CLEAN_FILES)" || rm -f $(CLEAN_FILES)

%.png: %.uml
	$(PLANTUML) $<

CLEAN_FILES = \
	$(uml_PNG) \
	$(NULL)

GITIGNOREFILES = \
	$(uml_PNG) \
	$(NULL)

endif

-include $(top_srcdir)/git.mk
