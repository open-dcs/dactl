EXTRA_DIST =

tests_valaflags = \
	--vapidir=$(top_srcdir)/src/libdcs-core \
	--pkg posix \
	--pkg gio-2.0 \
	--pkg gee-0.8 \
	--pkg json-glib-1.0 \
	--pkg dcs-build \
	--pkg dcs-core-0.1 \
	$(NULL)

tests_cflags = \
	$(DEBUG_CFLAGS) \
	$(LIBDCS_CORE_CFLAGS) \
	-I$(top_srcdir)/src/libdcs-core \
	$(NULL)

tests_libs = \
	$(LIBDCS_CORE_LIBS) \
	$(top_builddir)/src/libdcs-core/libdcs-core-0.1.la \
	$(NULL)

tests_ldflags = \
	-export-dynamic \
	$(NULL)

TESTS_ENVIRONMENT = \
	GI_TYPELIB_PATH="$(top_builddir)/src/libdcs-core:$(GI_TYPELIB_PATH)" \
	G_TEST_SRCDIR="$(abs_srcdir)" \
	G_TEST_BUILDDIR="$(abs_builddir)" \
	G_DEBUG=gc-friendly \
	MALLOC_CHECK_=2 \
	MALLOC_PERTURB_=$$(($${RANDOM:-256} % 256))

LOG_COMPILER = $(top_srcdir)/build/autotools/tap-test

tests_common_sources = \
	test-case.vala \
	$(NULL)

TESTS = test-dcs-core

test_dcs_core_SOURCES = \
	$(tests_common_sources) \
	test-dcs-core.vala \
	test-dcs-object.vala \
	test-dcs-config.vala \
	$(NULL)

test_dcs_core_VALAFLAGS = $(tests_valaflags)
test_dcs_core_CFLAGS = $(tests_cflags)
test_dcs_core_LDADD = $(tests_libs)
test_dcs_core_LDFLAGS = $(tests_ldflags)

if ENABLE_TESTS
noinst_PROGRAMS = $(TESTS)
endif

check_PROGRAMS = $(TESTS)

-include $(top_srcdir)/git.mk
