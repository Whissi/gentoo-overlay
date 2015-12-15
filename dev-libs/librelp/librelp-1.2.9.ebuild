# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils

DESCRIPTION="An easy to use library for the RELP protocol"
HOMEPAGE="http://www.librelp.com/"
SRC_URI="http://download.rsyslog.com/${PN}/${P}.tar.gz"

LICENSE="GPL-3 doc? ( FDL-1.3 )"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ~sparc x86"
IUSE="debug doc +ssl static-libs"

RDEPEND="
	ssl? ( >=net-libs/gnutls-2.12.23-r1 )
"

DEPEND="
	ssl? ( >=net-libs/gnutls-2.12.23-r1 )
	virtual/pkgconfig
"

AUTOTOOLS_IN_SOURCE_BUILD=1

PATCHES=()

src_prepare() {
	sed -i \
		-e 's/ -g"/"/g' \
		configure.ac || die "sed failed"

	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_enable ssl tls)
	)

	autotools-utils_src_configure
}

src_install() {
	use doc && HTML_DOCS=( doc/relp.html )
	autotools-utils_src_install
}
