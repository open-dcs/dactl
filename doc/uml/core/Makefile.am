if ENABLE_UML

uml_UML = \
	abstract-buildable.uml \
	abstract-config.uml \
	abstract-container.uml \
	abstract-object.uml \
	app-controller.uml \
	app-model.uml \
	app-view.uml \
	application.uml \
	buildable.uml \
	cld-adapter.uml \
	config-node.uml \
	config.uml \
	container.uml \
	dataseries.uml \
	dbus-interface.uml \
	enums.uml \
	factory.uml \
	legacy-config.uml \
	legacy-plugin.uml \
	message.uml \
	meta-config.uml \
	meta-factory.uml \
	module-loader.uml \
	node.uml \
	object.uml \
	plugin-extension.uml \
	plugin-information.uml \
	plugin-loader.uml \
	plugin-manager.uml \
	plugin.uml \
	point.uml \
	ref-container.uml \
	serializable.uml \
	syslog.uml \
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

