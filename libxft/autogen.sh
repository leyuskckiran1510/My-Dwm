#! /bin/sh

#sh autogen.sh --sysconfdir=/etc --prefix=/usr --mandir=/usr/share/man
srcdir=`dirname "$0"`
test -z "$srcdir" && srcdir=.

ORIGDIR=`pwd`
cd "$srcdir"

autoreconf -v --install || exit 1
cd "$ORIGDIR" || exit $?

git config --local --get format.subjectPrefix >/dev/null 2>&1 ||
    git config --local format.subjectPrefix "PATCH libXft"

if test -z "$NOCONFIGURE"; then
    exec "$srcdir"/configure "$@"
fi
