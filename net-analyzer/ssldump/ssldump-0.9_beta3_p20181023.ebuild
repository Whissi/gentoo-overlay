# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

AUTOTOOLS_IN_SOURCE_BUILD=1
AUTOTOOLS_AUTORECONF=1
inherit autotools eutils toolchain-funcs

MY_PV=${PV/_beta/b}
MY_P=${PN}-${MY_PV}
COMMIT="3f042afaea4362cd3706b2ae25ca22d3f24d76f1"

DESCRIPTION="An SSLv3/TLS network protocol analyzer"
HOMEPAGE="http://ssldump.sourceforge.net/ https://github.com/adulau/ssldump"
#SRC_URI="http://downloads.sourceforge.net/project/${PN}/${PN}/${MY_PV}/${MY_P}.tar.gz"
SRC_URI="https://github.com/adulau/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="openssl"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="+ssl"

RDEPEND="
	net-libs/libpcap
	ssl? ( >=dev-libs/openssl-1:= )
"
DEPEND="
	${RDEPEND}
"

#S=${WORKDIR}/${MY_P}
S="${WORKDIR}/${PN}-${COMMIT}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9-configure-dylib-r1.patch
	"${FILESDIR}"/${PN}-0.9-prefix-fix.patch
	"${FILESDIR}"/${PN}-0.9-declaration.patch
	"${FILESDIR}"/${PN}-0.9-includes.patch
	"${FILESDIR}"/${PN}-0.9-openssl-1.1-configure.patch
	"${FILESDIR}"/${PN}-0.9-use-openssl-1.1-getter-and-setter.patch
)

src_prepare() {
	default

	mv configure.in configure.ac || die

	eautoreconf
}

src_configure() {
	tc-export CC

	econf \
		--with-pcap-inc="${EPREFIX%/}/usr/include" \
		--with-pcap-lib="${EPREFIX%/}/usr/$(get_libdir)" \
		$(usex ssl --with-openssl-inc="${EPREFIX%/}/usr/include" '--without-openssl') \
		$(usex ssl --with-openssl-lib="${EPREFIX%/}/usr/$(get_libdir)" '--without-openssl')
}

src_install() {
	dosbin ssldump
	doman ssldump.1
	dodoc ChangeLog CREDITS README
}
