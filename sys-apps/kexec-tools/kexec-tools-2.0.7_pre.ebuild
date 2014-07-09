# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/kexec-tools/kexec-tools-2.0.4-r3.ebuild,v 1.1 2013/12/28 20:16:29 jlec Exp $

EAPI=5

inherit autotools-utils flag-o-matic linux-info systemd

MY_PV="${PV%_*}"
MY_P="${PN}-${MY_PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Load another kernel from the currently executing Linux kernel"
HOMEPAGE="http://kernel.org/pub/linux/utils/kernel/kexec/"
SRC_URI="mirror://kernel/linux/utils/kernel/kexec/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="booke lzma xen zlib"

REQUIRED_USE="lzma? ( zlib )"

DEPEND="
	lzma? ( app-arch/xz-utils )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}"

CONFIG_CHECK="~KEXEC"

PATCHES=(
		"${FILESDIR}"/${PVR}/10-disable-kexec-test.patch
		"${FILESDIR}"/${PVR}/20-out-of-source.patch
	)

pkg_setup() {
	# GNU Make's $(COMPILE.S) passes ASFLAGS to $(CCAS), CCAS=$(CC)
	export ASFLAGS="${CCASFLAGS}"
	# to disable the -fPIE -pie in the hardened compiler
	if gcc-specs-pie ; then
		filter-flags -fPIE
		append-ldflags -nopie
	fi
}

src_configure() {
	local myeconfargs=(
		$(use_with booke)
		$(use_with lzma)
		$(use_with xen)
		$(use_with zlib)
		)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	dodoc "${FILESDIR}"/${PVR}/README.Gentoo

	newinitd "${FILESDIR}"/${PVR}/kexec.initd kexec
	newconfd "${FILESDIR}"/${PVR}/kexec.confd kexec

	insinto /etc
	doins "${FILESDIR}"/${PVR}/kexec.conf

	insinto /etc/kernel/postinst.d
	doins "${FILESDIR}"/${PVR}/90_kexec

	systemd_dounit "${FILESDIR}"/${PVR}/kexec.service
}

pkg_postinst() {
	if systemd_is_booted || has_version sys-apps/systemd; then
		elog "For systemd support the new config file is"
		elog "   /etc/kexec.conf"
		elog "Please adopt it to your needs as there is no autoconfig anymore"
	fi
}
