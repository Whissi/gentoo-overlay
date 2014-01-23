# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils eutils

DESCRIPTION="Liblogging is an easy to use, portable, open source library for system logging."
HOMEPAGE="http://www.liblogging.org"
SRC_URI="https://github.com/rsyslog/liblogging/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0/0"
KEYWORDS="~amd64 ~arm ~hppa ~x86 ~amd64-linux"
IUSE="rfc3195 static-libs +stdlog"

RDEPEND=""

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

DOCS=( ChangeLog )

src_prepare() {
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable rfc3195)
		$(use_enable stdlog)
	)

	autotools-utils_src_configure
}
