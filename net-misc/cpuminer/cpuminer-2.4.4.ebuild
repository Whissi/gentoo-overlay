# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="Multi-threaded CPU miner for Litecoin and Bitcoin"
HOMEPAGE="https://github.com/pooler/cpuminer"
SRC_URI="https://github.com/pooler/${PN}/releases/download/v${PV}/pooler-${PN}-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/jansson
	net-misc/curl"
RDEPEND="net-misc/curl"

src_prepare() {
	default

	eautoreconf
}
