if ENABLE_DOC

uml_UML = \
	dcs-activity.uml \
	dcs-class.uml \
	dcs-component.uml \
	dcs-sequence.uml \
	dcs-state.uml \
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
