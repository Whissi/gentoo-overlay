# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit toolchain-funcs eutils

MY_BASED_ON="0.6"
MY_PV="${PV%_*}"
MY_P="${PN}-${MY_BASED_ON}"
S="${WORKDIR}/${MY_P}"

SRC_URI="http://dev.gentoo.org/~blueness/${PN}/${MY_P}.tar.bz2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"

DESCRIPTION="base functions required by all gentoo systems"
HOMEPAGE="http://www.gentoo.org"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}/bug_506704.patch"
	tc-export CC
}
