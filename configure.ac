#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ(2.59)
AC_INIT([libspf2], [1.2.10], [libspf2@anarres.org])
AC_CONFIG_AUX_DIR(config)
AM_INIT_AUTOMAKE
AC_CONFIG_SRCDIR([src/libspf2/spf_server.c])
AM_CONFIG_HEADER(config.h)
AC_CONFIG_MACRO_DIR([m4])

dnl AC_USE_SYSTEM_EXTENSIONS

# remember the version info for later

KV_MAJOR=`echo $PACKAGE_VERSION | sed 's/^\([[0-9]]*\)\.[[0-9]]*\.[[0-9]]*/\1/'`
KV_MINOR=`echo $PACKAGE_VERSION | sed 's/^[[0-9]]*\.\([[0-9]]*\)\.[[0-9]]*/\1/'`
KV_PATCH=`echo $PACKAGE_VERSION | sed 's/^[[0-9]]*\.[[0-9]]*\.\([[0-9]]*\)/\1/'`
AC_SUBST([KV_MAJOR])
AC_SUBST([KV_MINOR])
AC_SUBST([KV_PATCH])

cat >src/include/spf_lib_version.h <<_EOF_VERSION
/**
 * @file
 * @brief Autogenerated configuration information - do not edit.
 */
#ifndef INC_SPF_VERSION
#define INC_SPF_VERSION

#define SPF_LIB_VERSION_MAJOR	$KV_MAJOR
#define SPF_LIB_VERSION_MINOR	$KV_MINOR
#define SPF_LIB_VERSION_PATCH	$KV_PATCH

#endif
_EOF_VERSION

AX_WITH_PERL
PERL_SUBDIRS=""
AC_SUBST([PERL_SUBDIRS])
AC_ARG_ENABLE(perl,
	AC_HELP_STRING([--enable-perl],
		[build the Perl/XS interface to libspf2]),
[
	PERL_SUBDIRS="perl"
	AC_CONFIG_COMMANDS([perl/Makefile], [
		# XXX This needs to use $PERL, somehow.
		( cd perl && perl Makefile.PL )
	])
])


# Checks for programs.
AC_PROG_CC
if test "X$ac_cv_prog_gcc" = "Xyes"; then
        gcc_ver=`gcc -v 2>&1 | grep version | sed 's/.*gcc version \([[0-9]][[0-9]]*\)\..*/\1/'`
#        echo "GCC version: $gcc_ver"
        if test "X$gcc_ver" = "X3"; then
        	CFLAGS="$CFLAGS -W -Wall -Wmissing-prototypes -Wwrite-strings"
#        	CFLAGS="$CFLAGS -std=c89 -D_BSD_SOURCE -W -Wall -Wmissing-prototypes -Wwrite-strings"
#        	CFLAGS="$CFLAGS -std=c99 -W -Wall -Wmissing-prototypes -Wwrite-strings"
#        	CFLAGS="$CFLAGS -std=gnu99 -W -Wall -Wmissing-prototypes -Wwrite-strings"
        else
        	CFLAGS="$CFLAGS -Wall"
        fi
fi
AC_PROG_CPP
AC_SUBST([SUBDIRS])
AC_PROG_MAKE_SET
AC_SUBST([LIBPROGS])
AC_PROG_LIBTOOL
AC_PROG_INSTALL
AC_PROG_LN_S
dnl This is obsolete
dnl AC_PROG_RANLIB

# Check if the linker accepts --rpath (for Darwin)
AC_MSG_CHECKING([if ld accepts --rpath])
SAVEDLDFLAGS=$LDFLAGS
LDFLAGS=$LDFLAGS" -Wl,--rpath=/"
AC_LINK_IFELSE([AC_LANG_PROGRAM([],[])],
    [rpath="--rpath="; ldrpath=yes], [rpath="-L"; ldrpath=no])
LDFLAGS=$SAVEDLDFLAGS
AC_MSG_RESULT([$ldrpath])

# Checks for header files.
AC_HEADER_STDC
AC_HEADER_SYS_WAIT
AC_HEADER_TIME
AC_CHECK_SIZEOF([int])
AC_CHECK_HEADERS([limits.h sys/param.h syslog.h sys/time.h errno.h sys/types.h])
AC_CHECK_HEADERS([fcntl.h malloc.h nmemory.h stddef.h inttypes.h stdlib.h string.h strings.h unistd.h stdarg.h])
AC_CHECK_HEADERS([pthread.h pwd.h grp.h libintl.h getopt.h])
AC_CHECK_HEADERS([netdb.h netinet/in.h sys/socket.h arpa/inet.h arpa/nameser.h])
AC_CHECK_HEADERS([resolv.h], [], [], [[
	#if HAVE_SYS_TYPES_H
	#  include <sys/types.h>
	#endif
	#ifdef HAVE_SYS_SOCKET_H
	#  include <sys/socket.h> /* DNS HEADER struct */
	#endif
	#ifdef HAVE_NETINET_IN_H
	#  include <netinet/in.h>   /* inet_ functions / structs */
	#endif
	#ifdef HAVE_ARPA_NAMESER_H
	#  include <arpa/nameser.h> /* DNS HEADER struct */
	#endif
	]])
dnl XXX This is no longer true.
AC_CHECK_HEADER(pthread.h, , [
	echo "pthread.h is required to build this program."
	exit 1;
])

dnl Moved to after header checks by Shevek
AC_ARG_WITH(bind,
        [  --with-bind=DIR  Find BIND resolver in DIR],
        [AC_CHECK_FILE([$withval/include/bind/resolv.h],
                [CFLAGS="$CFLAGS -I$withval/include/bind"],
                [CFLAGS="$CFLAGS -I$withval/include"])
         LDFLAGS="$LDFLAGS -L$withval/lib -Wl,$rpath$withval/lib"
         AC_CHECK_LIB([bind], [res_query], [LIBS="$LIBS -lbind"],
                [AC_CHECK_LIB([resolv],
                        [res_query],
                        [LIBS="$LIBS -lresolv"],
                        [echo "cannot find resolver library"; exit 1;])
                ])
        ],
		[dnl Have to include resolv.h as res_query is sometimes defined as a macro
				AC_MSG_CHECKING([for res_query in -lresolv (with resolv.h if present)])
				saved_libs="$LIBS"
				LIBS="-lresolv $LIBS"
				AC_TRY_LINK([
						#ifdef HAVE_RESOLV_H
						#include <resolv.h>
						#endif],
						[res_query(0,0,0,0,0)],
						[AC_MSG_RESULT(yes)
								have_res_query=yes],
						[AC_MSG_RESULT(no)
								LIBS="$saved_libs"])
        ])
		
		
		
dnl [AC_CHECK_LIB(resolv, res_query)])

# Checks for libraries.
AC_CHECK_LIB(nsl, inet_pton)
AC_CHECK_LIB(socket, socket)
AC_CHECK_LIB(intl, gettext)
AC_CHECK_LIB(pthread, pthread_create)


# Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST
AC_C_INLINE
AC_TYPE_PID_T
AC_TYPE_UID_T
AC_TYPE_SIZE_T
AC_C_VOLATILE
AC_C_BIGENDIAN
AC_C_INLINE
AC_C_CHAR_UNSIGNED
AC_CHECK_TYPES([u_char, u_int8_t, u_int16_t, u_int32_t, uint8_t, uint16_t, uint32_t])
AC_CHECK_TYPES([ns_type], [], [], [[
	#ifdef HAVE_SYS_TYPES_H
	# include <sys/types.h>
	#endif
	#ifdef HAVE_SYS_SOCKET_H
	# include <sys/socket.h>		/* inet_ functions / structs */
	#endif
	#ifdef HAVE_NETINET_IN_H
	# include <netinet/in.h>		/* inet_ functions / structs */
	#endif
	#ifdef HAVE_ARPA_NAMESER_H
	# include <arpa/nameser.h> /* DNS HEADER struct */
	#endif
	]])
AC_CHECK_TYPES([struct in6_addr], [], [], [[
	#ifdef HAVE_NETINET_IN_H
	# include <netinet/in.h>   /* inet_ functions / structs */
	#endif
	]])

# Checks for library functions.
AC_FUNC_FORK
AC_FUNC_MALLOC
AC_FUNC_MEMCMP
AC_FUNC_REALLOC
AC_FUNC_SETPGRP
AC_FUNC_SELECT_ARGTYPES
AC_TYPE_SIGNAL


# It is not clear if BIND8 and/or BIND9 require the use of the
# res_ninit() and res_nquery() functions when threading, but it is
# safest to use them.

# Nowadays, I think libspf2 requires this function to be available.
AC_CHECK_DECLS([res_ninit], [], [], [[
	#ifdef HAVE_SYS_TYPES_H
	# include <sys/types.h>
	#endif
	#ifdef HAVE_SYS_SOCKET_H
	# include <sys/socket.h>		/* inet_ functions / structs */
	#endif
	#ifdef HAVE_NETINET_IN_H
	# include <netinet/in.h>		/* inet_ functions / structs */
	#endif
	#ifdef HAVE_ARPA_NAMESER_H
	#  include <arpa/nameser.h> /* DNS HEADER struct */
	#endif
	#ifdef HAVE_RESOLV_H
	# include <resolv.h>
	#endif
	]])
AC_CHECK_DECLS([res_ndestroy], [], [], [[
	#ifdef HAVE_SYS_TYPES_H
	# include <sys/types.h>
	#endif
	#ifdef HAVE_SYS_SOCKET_H
	# include <sys/socket.h>		/* inet_ functions / structs */
	#endif
	#ifdef HAVE_NETINET_IN_H
	# include <netinet/in.h>		/* inet_ functions / structs */
	#endif
	#ifdef HAVE_ARPA_NAMESER_H
	#  include <arpa/nameser.h> /* DNS HEADER struct */
	#endif
	#ifdef HAVE_RESOLV_H
	# include <resolv.h>
	#endif
	]])

AC_CHECK_DECLS([ns_t_spf], [], [], [[
	#ifdef HAVE_SYS_TYPES_H
	# include <sys/types.h>
	#endif
	#ifdef HAVE_SYS_SOCKET_H
	# include <sys/socket.h>		/* inet_ functions / structs */
	#endif
	#ifdef HAVE_NETINET_IN_H
	# include <netinet/in.h>		/* inet_ functions / structs */
	#endif
	#ifdef HAVE_ARPA_NAMESER_H
	#  include <arpa/nameser.h> /* DNS HEADER struct */
	#endif
	#ifdef HAVE_RESOLV_H
	# include <resolv.h>
	#endif
	]])

AC_CHECK_DECLS([ns_t_invalid], [], [], [[
	#ifdef HAVE_SYS_TYPES_H
	# include <sys/types.h>
	#endif
	#ifdef HAVE_SYS_SOCKET_H
	# include <sys/socket.h>		/* inet_ functions / structs */
	#endif
	#ifdef HAVE_NETINET_IN_H
	# include <netinet/in.h>		/* inet_ functions / structs */
	#endif
	#ifdef HAVE_ARPA_NAMESER_H
	#  include <arpa/nameser.h> /* DNS HEADER struct */
	#endif
	#ifdef HAVE_RESOLV_H
	# include <resolv.h>
	#endif
	]])

AC_CHECK_FUNCS([ftruncate gethostname memmove memset socket])
AC_CHECK_FUNCS([strchr strcspn strdup strerror])
AC_CHECK_FUNCS([strcasecmp strncasecmp strspn strtoul])
AC_CHECK_FUNCS([gethostbyname inet_ntoa select strrchr strstr strtol])

AC_REPLACE_FUNCS([getopt_long_only strncasecmp])
AC_REPLACE_FUNCS([__ns_initparse __ns_name_uncompress __ns_msg_getflag])
dnl Magnus Holmgren says this avoids linking a private function
AC_LIBOBJ([__ns_get16])

AC_CONFIG_FILES([Makefile
                 Doxyfile
                 src/Makefile
                 src/include/Makefile
                 src/libreplace/Makefile
                 src/libspf2/Makefile
                 src/spfquery/Makefile
                 src/spftest/Makefile
                 src/spfd/Makefile
                 src/spf_example/Makefile])
AC_OUTPUT
