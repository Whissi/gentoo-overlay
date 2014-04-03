# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit rpm linux-info

DESCRIPTION="HP Lights-Out Online Configuration Utility (HPONCFG)"
HOMEPAGE="http://h20565.www2.hp.com/portal/site/hpsc/public/psi/home/?sp4ts.oid=5219994"
SRC_URI="
	amd64? ( http://downloads.linux.hp.com/SDR/repo/spp/RHEL/6/x86_64/current/${P}-0.x86_64.rpm )
	x86? ( http://downloads.linux.hp.com/SDR/repo/spp/RHEL/6/i386/current/${P}-0.i386.rpm )
"

LICENSE="hp-proliant-essentials"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="elibc_glibc? ( sys-libs/glibc )"

S="${WORKDIR}"

CONFIG_CHECK="~HP_ILO"

QA_PREBUILT="/usr/sbin/hponcfg /usr/lib*/libcpqci*.so.3"

src_install() {
	dosbin sbin/hponcfg

	# When bumping, verify SONAME (scanelf -S libhponcfg64.so)!
	if use amd64; then
		newlib.so "${S}"/usr/lib64/libhponcfg64.so libcpqci64.so.3
		dosym libcpqci64.so.3 /usr/$(get_libdir)/libhponcfg64.so
	elif use x86; then
		newlib.so "${S}"/usr/lib/libhponcfg.so libcpqci.so.3
		dosym libcpqci.so.3 /usr/$(get_libdir)/libhponcfg.so
	fi

	dodoc "${S}"/usr/share/doc/hponcfg/*
}
