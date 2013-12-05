# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils toolchain-funcs systemd user

MY_PV="${PV%_p*}"
DEBIAN_PATCHLEVEL="${PV#*_p}"

DESCRIPTION="Lightweight NTP server ported from OpenBSD"
HOMEPAGE="http://www.openntpd.org/"
SRC_URI="
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${MY_PV}.orig.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${MY_PV}-${DEBIAN_PATCHLEVEL}.debian.tar.gz
"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="ssl selinux"

DEPEND="
	ssl? ( dev-libs/openssl )
	virtual/yacc
"

RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-ntp )
	!net-misc/ntp[-openntpd]
"

S="${WORKDIR}/${PN}-${MY_PV}"

NTP_HOMEDIR="/var/empty"
NTP_STATEDIR="/var/lib/${PN}"

pkg_setup() {
	enewgroup ntp
	enewuser ntp -1 -1 "${NTP_HOMEDIR}" ntp

	local ntp_home_current=$(egethome ntp)

	if [[ ${ntp_home_current} != ${NTP_HOMEDIR} ]]; then
		# Seems like the user switched from net-misc/ntp to net-misc/openntpd
		# That's why we are adjusting the HOME directory...
		esethome ntp "${NTP_HOMEDIR}"
	fi
}

src_prepare() {
	epatch "${WORKDIR}"/debian/patches/*.patch
	einfo "Applying Gentoo patches:"
	epatch "${FILESDIR}/"${PVR}/*.patch
	sed -i 's:debian:gentoo:g' ntpd.conf || die "Setting gentoo's time servers in \"ntpd.conf\" failed!"

	epatch_user

	# At least the Debian patches have touched the .ac files
	# therefore we need to call autoreconf
	eautoreconf
}

src_configure() {
	econf \
		--disable-strip \
		--localstatedir="${NTP_STATEDIR}" \
		--with-privsep-user=ntp \
		--with-privsep-path="${NTP_HOMEDIR}" \
		$(use_with !ssl builtin-arc4random) \
		AR="$(type -p $(tc-getAR))"
}

src_install() {
	default

	local ntp_statedir="${ED}${NTP_STATEDIR#/}"
	mkdir --parent "${ntp_statedir}" || die "Couldn't create state directory \"${ntp_statedir}\""

	newconfd "${FILESDIR}"/${PVR}/${PN}.confd ntpd
	newinitd "${FILESDIR}"/${PVR}/${PN}.initd ntpd

	systemd_newunit "${FILESDIR}"/${PVR}/${PN}.systemd ntpd.service
}

pkg_prerm() {
	if [[ -z ${REPLACED_BY_VERSION} ]] ; then
		local drift_file="${EROOT}${NTP_STATEDIR#/}/ntpd.drift"
		if [ -f "${drift_file}" ]; then
			ebegin "Removing drift file \"${drift_file}\""
				rm "${drift_file}"
			eend $?
		fi
	fi
}
