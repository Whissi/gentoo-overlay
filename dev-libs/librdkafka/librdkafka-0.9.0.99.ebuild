# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit

DESCRIPTION="Apache Kafka C/C++ client library"
HOMEPAGE="https://github.com/edenhill/librdkafka"
SRC_URI="https://github.com/edenhill/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"

# subslot = soname version
SLOT="0/1"

KEYWORDS="~amd64 ~arm ~hppa ~x86"
IUSE="sasl ssl static-libs"

RDEPEND="
	sasl? ( dev-libs/cyrus-sasl:= )
	ssl? ( dev-libs/openssl:0= )
	sys-libs/zlib
"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

DOCS=( README.md CONFIGURATION.md INTRODUCTION.md LICENSE LICENSE.pycrc LICENSE.snappy )

src_configure() {
	local myeconf=(
		--no-cache
		--no-download
		$(use_enable sasl)
		$(usex static-libs '--enable-static' '')
		$(use_enable ssl)
	)

	econf ${myeconf[@]}
}

src_test() {
	emake -C tests run_local
}

src_install() {
	default

	use static-libs || find "${ED}"usr/lib* -name '*.la' -o -name '*.a' -delete
}
