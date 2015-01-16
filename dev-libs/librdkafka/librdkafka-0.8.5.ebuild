# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

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

DOCS=( README.md )

src_configure() {
	econf $(usex static-libs '--enable-static' '')
}

src_compile() {
	# Parallel build is currently broken, see upstream issue #179
	emake --jobs 1
}
