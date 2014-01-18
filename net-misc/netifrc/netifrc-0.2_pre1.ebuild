# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Gentoo Network Interface Management Scripts"
HOMEPAGE="http://www.gentoo.org/proj/en/base/openrc/"

MY_P=${P/_/-}

SRC_URI="http://mirror.deutschmann.io/gentoo/distfiles/${MY_P}.tar.xz"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"

LICENSE="BSD-2"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=">=sys-apps/openrc-0.12
	!<sys-apps/openrc-0.12"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${WORKDIR}"/patches/*.patch

	sed -i 's:0444:0644:' mk/sys.mk || die
	sed -i "/^DIR/s:/${PN}:/${PF}:" doc/Makefile || die #241342

	# Allow user patches to be applied without modifying the ebuild
	epatch_user
}

src_compile() {
	MAKE_ARGS="${MAKE_ARGS} LIBEXECDIR=${EPREFIX}/lib/${PN}"

	use prefix && MAKE_ARGS="${MAKE_ARGS} MKPREFIX=yes PREFIX=${EPREFIX}"

	emake ${MAKE_ARGS} all
}

src_install() {
	emake ${MAKE_ARGS} DESTDIR="${D}" install
}

pkg_postinst() {
	if [[ ! -e "${EROOT}"/etc/conf.d/net && -z $REPLACING_VERSIONS ]]; then
		elog "The network configuration scripts will use dhcp by"
		elog "default to set up your interfaces."
		elog "If you need to set up something more complete, see"
		elog "${EROOT}/usr/share/doc/${P}/README"
	fi
}
