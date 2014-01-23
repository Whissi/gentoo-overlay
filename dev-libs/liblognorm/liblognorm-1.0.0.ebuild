# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils

DESCRIPTION="Fast samples-based log normalization library"
HOMEPAGE="http://www.liblognorm.com"
SRC_URI="http://www.liblognorm.com/files/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/1"
KEYWORDS="~amd64 ~arm ~hppa ~x86 ~amd64-linux"
#IUSE="debug static-libs" - "debug" disabled due to http://bugzilla.adiscon.com/show_bug.cgi?id=508
IUSE="static-libs"

RDEPEND="
	>=dev-libs/libestr-0.1.3
	>=dev-libs/json-c-0.11:=
"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

DOCS=( ChangeLog )

src_configure() {
	local myeconfargs=(
		#$(use_enable debug) - "debug" disabled due to http://bugzilla.adiscon.com/show_bug.cgi?id=508
	)

	autotools-utils_src_configure
}
