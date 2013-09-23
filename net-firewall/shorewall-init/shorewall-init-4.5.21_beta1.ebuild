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
	|| ( =net-firewall/shorewall-${PVR} =net-firewall/shorewall6-${PVR} =net-firewall/shorewall-lite-${PVR} =net-firewall/shorewall6-lite-${PVR} )
"

S=${WORKDIR}/${MY_P}

src_prepare() {
	cp "${FILESDIR}"/${PVR}/shorewallrc "${S}"/shorewallrc.gentoo || die "Copying shorewallrc failed"
	eprefixify "${S}"/shorewallrc.gentoo

	cp "${FILESDIR}"/${PVR}/${PN}.confd "${S}"/default.gentoo || die "Copying ${PN}.confd failed"

	cp "${FILESDIR}"/${PVR}/${PN}.initd "${S}"/init.gentoo.sh || die "Copying ${PN}.initd failed"
	eprefixify "${S}"/init.gentoo.sh

	cp "${FILESDIR}"/${PVR}/${PN}.systemd "${S}"/gentoo.service || die "Copying ${PN}.systemd failed"

	epatch "${FILESDIR}"/${PVR}/install.sh_01-Add-Gentoo-support.patch
	epatch "${FILESDIR}"/${PVR}/shorewall-init_01-Use-SYSCONFDIR-variable-in-error-msg.patch
	epatch "${FILESDIR}"/${PVR}/shorewall-init_02-Remove-ipset-functionality.patch
	epatch_user
}

src_configure() {
	:;
}

src_compile() {
	:;
}

src_install() {
	DESTDIR="${D}" ./install.sh shorewallrc.gentoo || die "install.sh failed"

	if [ -d "${D}/etc/logrotate.d" ]; then
		# On Gentoo, shorewall-init will not create shorewall-ifupdown.log,
		# so we don't need a logrotate folder at all
		rm -rf "${D}"/etc/logrotate.d
	fi

	if [ -d "${D}/etc/NetworkManager" ]; then
		# On Gentoo, we don't support NetworkManager
		# so we don't need these folder at all
		rm -rf "${D}"/etc/NetworkManager
	fi

	if [ -f "${D}/usr/share/shorewall-init/ifupdown" ]; then
		# This script won't work on Gentoo
		rm -rf "${D}"/usr/share/shorewall-init/ifupdown
	fi

	dodoc "${FILESDIR}"/${PVR}/README.Gentoo.txt
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
