# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils linux-info prefix systemd versionator

MY_URL_PREFIX=
case ${P} in
	*_beta* | \
	*_rc*)
		MY_URL_PREFIX='development/'
		;;
esac

MY_PV=${PV/_rc/-RC}
MY_PV=${MY_PV/_beta/-Beta}
MY_P=${PN}-${MY_PV}
MY_P_DOCS=shorewall-docs-html-${MY_PV}

MY_MAJORMINOR=$(get_version_component_range 1-2)

DESCRIPTION='The Shoreline Firewall, more commonly known as "Shorewall", is'
DESCRIPTION+=' a high-level tool for configuring Netfilter. This package is'
DESCRIPTION+=' for IPv6 support.'
HOMEPAGE="http://www.shorewall.net/"
SRC_URI="
	http://www.shorewall.net/pub/shorewall/${MY_URL_PREFIX}${MY_MAJORMINOR}/shorewall-${MY_PV}/${MY_P}.tar.bz2
	doc? ( http://www.shorewall.net/pub/shorewall/${MY_URL_PREFIX}${MY_MAJORMINOR}/shorewall-${MY_PV}/${MY_P_DOCS}.tar.bz2 )
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc"

DEPEND="=net-firewall/shorewall-${PV}"
RDEPEND="
	${DEPEND}
	>=net-firewall/iptables-1.4.20[ipv6]
	sys-apps/iproute2[-minimal]
	dev-perl/Socket6
"

S=${WORKDIR}/${MY_P}

pkg_pretend() {
	local CONFIG_CHECK="~NF_CONNTRACK ~NF_CONNTRACK_IPV6"
	
	local WARNING_CONNTRACK="Without NF_CONNTRACK support, you will be unable"
	local WARNING_CONNTRACK+=" to run ${PN} on the local system."
	
	local WARNING_CONNTRACK_IPV6="Without NF_CONNTRACK_IPV6 support, you will"
	local WARNING_CONNTRACK_IPV6+=" be unable to run ${PN} on the local system."
	
	check_extra_config
}

src_prepare() {
	cp "${FILESDIR}"/${PV}/shorewallrc_new "${S}"/shorewallrc.gentoo || die "Copying shorewallrc_new failed"
	eprefixify "${S}"/shorewallrc.gentoo
	
	cp "${FILESDIR}"/${PV}/${PN}.initd "${S}"/init.gentoo.sh || die "Copying shorewall.initd failed"
	
	epatch "${FILESDIR}"/${PV}/shorewall6.conf-SUBSYSLOCK.patch
	epatch_user
}

src_configure() {
	:;
}

src_compile() {
	:;
}

src_install() {
	keepdir /var/lib/${PN}

	DESTDIR="${D}" ./install.sh shorewallrc.gentoo || die "install.sh failed"
	systemd_newunit "${FILESDIR}"/${PV}/${PN}.systemd ${PN}.service

	dodoc changelog.txt releasenotes.txt
	if use doc; then
		dodoc -r Samples6
		cd "${WORKDIR}"/${MY_P_DOCS}
		dohtml -r *
	fi
}
