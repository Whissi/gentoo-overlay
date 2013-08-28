# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils versionator prefix

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

MY_MAJORMINOR=$(get_version_component_range 1-2)

DESCRIPTION="Component to secure a Shorewall-protected system at boot time prior to bringing up the network."
HOMEPAGE="http://www.shorewall.net/"
SRC_URI="http://www1.shorewall.net/pub/shorewall/${MY_URL_PREFIX}${MY_MAJORMINOR}/shorewall-${MY_PV}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	${DEPEND}
	|| ( =net-firewall/shorewall-${PV} =net-firewall/shorewall6-${PV} =net-firewall/shorewall-lite-${PV} =net-firewall/shorewall6-lite-${PV} )
"

S=${WORKDIR}/${MY_P}

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
	newinitd "${FILESDIR}"/${PV}/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PV}/${PN}.confd ${PN}

	eprefixify "${D}"/etc/init.d/${PN}

	dodoc "${FILESDIR}"/${PV}/README.Gentoo.txt
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		# This is a new installation
		elog "Before you can use ${PN}, you need to edit its configuration in:"
		elog ""
		elog "  ${EPREFIX}/etc/conf.d/${PN}"
		elog ""
		elog "To use ${PN}, please add ${PN} to your boot runlevel:"
		elog ""
		elog "  # rc-update add ${PN} boot"
		elog ""
		ewarn "Notice:"
		ewarn "${PN} is more like a start script than a service."
		ewarn "Therefore you cannot start or stop ${PN} at default runlevel."
		ewarn ""
		ewarn "For more information read ${EPREFIX}/usr/share/doc/${PF}/README.Gentoo.txt.bz2"
	fi
}
