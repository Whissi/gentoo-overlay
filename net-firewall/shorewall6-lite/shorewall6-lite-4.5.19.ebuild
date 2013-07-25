# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit linux-info systemd versionator

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

DESCRIPTION="An iptables-based firewall whose config is handled by a normal Shorewall6."
HOMEPAGE="http://www.shorewall.net/"
SRC_URI="
	http://www.shorewall.net/pub/shorewall/${MY_URL_PREFIX}${MY_MAJORMINOR}/shorewall-${MY_PV}/${MY_P}.tar.bz2
	doc? ( http://www.shorewall.net/pub/shorewall/${MY_URL_PREFIX}${MY_MAJORMINOR}/shorewall-${MY_PV}/${MY_P_DOCS}.tar.bz2 )
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc"

DEPEND="=net-firewall/shorewall-core-${PV}"
RDEPEND="
	${DEPEND}
	>=net-firewall/iptables-1.4.1.1[ipv6]
	sys-apps/iproute2[-minimal]
	dev-perl/Socket6
"

S=${WORKDIR}/${MY_P}

pkg_pretend() {
	local CONFIG_CHECK="~NF_CONNTRACK ~NF_CONNTRACK_IPV6"
	
	local ERROR_CONNTRACK="${PN} requires NF_CONNTRACK support."
	
	local ERROR_CONNTRACK_IPV6="${PN} requires NF_CONNTRACK_IPV6 support."
	
	check_extra_config
}

src_prepare() {
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

	DESTDIR="${D}" ./install.sh "${FILESDIR}"/shorewallrc_new || die "install.sh failed"
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	systemd_newunit "${FILESDIR}"/shorewall6-lite.systemd ${PN}.service || die

	dodoc changelog.txt releasenotes.txt
	if use doc; then
		cd "${WORKDIR}/${MY_P_DOCS}"
		dohtml -r *
	fi
}
