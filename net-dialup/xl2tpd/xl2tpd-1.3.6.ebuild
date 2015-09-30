# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils systemd toolchain-funcs vcs-snapshot

DESCRIPTION="A modern version of the Layer 2 Tunneling Protocol (L2TP) daemon"
HOMEPAGE="http://www.xelerance.com/services/software/xl2tpd/"
SRC_URI="https://github.com/xelerance/${PN}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="dnsretry +kernel"

DEPEND="net-libs/libpcap"
RDEPEND="${DEPEND}
	net-dialup/ppp"
DEPEND+=" kernel? ( >=sys-kernel/linux-headers-2.6.23 )"

src_prepare() {
	sed -i Makefile -e 's| -O2||g' || die "sed Makefile"
	# The below patch is questionable. Why wasn't it submitted upstream? If it
	# ever breaks, it will just be removed. -darkside 20120914
	use dnsretry && epatch "${FILESDIR}/${PVR}/${PN}-dnsretry.patch"
}

src_compile() {
	tc-export CC
	export OSFLAGS="-DLINUX"
	use kernel && OSFLAGS+=" -DUSE_KERNEL"
	emake
}

src_install() {
	emake PREFIX=/usr DESTDIR="${D}" install
	dodoc CREDITS README.xl2tpd BUGS CHANGES TODO doc/README.patents doc/rfc2661.txt
	insinto /etc/xl2tpd
	newins doc/l2tpd.conf.sample xl2tpd.conf
	newins doc/l2tp-secrets.sample l2tp-secrets
	fperms 0600 /etc/xl2tpd/l2tp-secrets
	newinitd "${FILESDIR}"/${PVR}/xl2tpd.initd xl2tpd
	systemd_dounit "${FILESDIR}"/${PVR}/xl2tpd.service
	systemd_newtmpfilesd "${FILESDIR}"/${PVR}/xl2tpd.tmpfiles xl2tpd.conf
}
