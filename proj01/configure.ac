#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([heateq], [1.0], [jiaqi@ices.utexas.edu])
AC_CONFIG_SRCDIR([src])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE

ACLOCAL_AMFLAGS = -I m4

# Checks for programs.
AC_PROG_FC

# Checks for libraries.
AX_PATH_MASA([0.30],[yes])
AX_PATH_GRVY([0.32],[yes])
# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.

AC_OUTPUT(Makefile src/Makefile test/Makefile)
