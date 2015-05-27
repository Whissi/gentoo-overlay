# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
AUTOTOOLS_AUTORECONF=1

inherit eutils autotools-utils

DESCRIPTION="Test tool / traffic generator for SIP protocol"
HOMEPAGE="http://sipp.sourceforge.net/"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="
		git://github.com/SIPp/${PN}.git
		https://github.com/SIPp/${PN}.git
	"

	inherit git-r3
else
	MY_PV=${PV/_rc/-rc}
	S="${WORKDIR}/${PN}-${MY_PV}"
	SRC_URI="https://github.com/SIPp/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

IUSE="gsl pcap rtpstream sctp ssl"

RDEPEND="
	gsl? ( >=sci-libs/gsl-1.14 )
	pcap? ( >=net-libs/libpcap-1.6.2 )
	rtpstream? ( >=sys-libs/zlib-1.2.8 )
	sctp? ( >=net-misc/lksctp-tools-1.0.13 )
	ssl? ( >=dev-libs/openssl-0.9.8z:= )
"

DEPEND="
	${RDEPEND}
	>=sys-apps/help2man-1.45.1
	>=sys-devel/autoconf-archive-2014.02.28
	virtual/pkgconfig
"

DOCS=( README.md LICENSE.txt THANKS )

src_configure() {
	local myeconfargs=(
		$(use_with ssl openssl)
		$(use_with pcap)
		$(use_with rtpstream)
		$(use_with sctp)
		$(use_with gsl)
	)

	autotools-utils_src_configure
}
