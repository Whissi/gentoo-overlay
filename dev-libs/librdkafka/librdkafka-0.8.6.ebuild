# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Apache Kafka C/C++ client library"
HOMEPAGE="https://github.com/edenhill/librdkafka"
SRC_URI="https://github.com/edenhill/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0/1"
KEYWORDS="~amd64 ~arm ~hppa ~x86 ~amd64-linux"
IUSE="static-libs"

RDEPEND="
	sys-libs/zlib
"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

DOCS=( README.md CONFIGURATION.md INTRODUCTION.md LICENSE LICENSE.pycrc LICENSE.snappy )

src_prepare() {
	epatch "${FILESDIR}"/librdkafka-0.8.6-dont-add-debug-symbols.patch
	epatch "${FILESDIR}"/librdkafka-0.8.6-dont-use-werror.patch

	epatch_user
}

src_configure() {
	local myeconf=(
		--no-cache
		--no-download
		$(usex static-libs '--enable-static' '')
	)

	econf ${myeconf[@]}
}

src_install() {
	default

	insinto /usr/$(get_libdir)/pkgconfig
	doins rdkafka.pc
}
