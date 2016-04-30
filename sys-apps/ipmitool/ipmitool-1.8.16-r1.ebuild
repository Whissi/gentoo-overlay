# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools linux-info

DESCRIPTION="Utility for controlling IPMI enabled devices."
HOMEPAGE="http://ipmitool.sf.net/"
DEBIAN_PR="3.debian"
DEBIAN_P="${P/-/_}"
DEBIAN_PF="${DEBIAN_P}-${DEBIAN_PR}"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	https://launchpad.net/ubuntu/+archive/primary/+files/${DEBIAN_PF}.tar.xz"
#IUSE="freeipmi openipmi status"
IUSE="openipmi static"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~x86"
LICENSE="BSD"

# Note: ipmitool CAN be built against || ( sys-libs/openipmi sys-libs/freeipmi )
#       but it doesn't actually need either.
#       freeipmi disabled due to missing keywords
COMMON_DEPEND="dev-libs/openssl:0=
	openipmi? ( sys-libs/openipmi )"
	#freeipmi? ( sys-libs/freeipmi )

RDEPEND="${COMMON_DEPEND}
	!<sys-apps/openrc-0.18.4"
DEPEND="${COMMON_DEPEND}
		virtual/os-headers"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != buildonly ]] && use kernel_linux; then
		local warning_msg="Option is not set but required to connect to your IPMI!"
		local config=""

		config="IPMI_HANDLER"
		local CONFIG_CHECK="~${config}"
		local WARNING_IPMI_HANDLER="CONFIG_${config}:\t\t ${warning_msg}"

		config="IPMI_DEVICE_INTERFACE"
		CONFIG_CHECK+=" ~${config}"
		local WARNING_IPMI_DEVICE_INTERFACE="CONFIG_${config}:\t ${warning_msg}"

		config="IPMI_SI"
		CONFIG_CHECK+=" ~${config}"
		local WARNING_IPMI_SI="CONFIG_${config}:\t\t\t ${warning_msg}"

		check_extra_config
	fi
}

src_prepare() {
	[ -d "${S}"/debian ] && mv "${S}"/debian{,.package}
	ln -s "${WORKDIR}"/debian "${S}"
	for p in $(cat debian/patches/series) ; do
		eapply debian/patches/$p
	done

	default

	eautoreconf
}

src_configure() {
	# - LIPMI and BMC are the Solaris libs
	# - OpenIPMI is unconditionally enabled in the configure as there is compat
	# code that is used if the library itself is not available
	# FreeIPMI does build now, but is disabled until the other arches keyword it
	#	`use_enable freeipmi intf-free` \
	# --enable-ipmievd is now unconditional
	econf \
		$(use_enable static) \
		--enable-ipmishell \
		--enable-intf-lan \
		--enable-intf-lanplus \
		--enable-intf-open \
		--enable-intf-serial \
		--disable-intf-bmc \
		--disable-intf-dummy \
		--disable-intf-free \
		--disable-intf-imb \
		--disable-intf-lipmi \
		--disable-internal-md5 \
		--with-kerneldir=/usr --bindir=/usr/sbin \
		|| die "econf failed"
	# Fix linux/ipmi.h to compile properly. This is a hack since it doesn't
	# include the below file to define some things.
	echo "#include <asm/byteorder.h>" >>config.h
}

src_install() {
	emake DESTDIR="${D%/}" PACKAGE="${PF}" install || die "emake install failed"

	into /usr
	dosbin contrib/bmclanconf
	rm -f "${D}"/usr/share/doc/${PF}/COPYING
	docinto contrib
	cd "${S}"/contrib
	dodoc collect_data.sh create_rrds.sh create_webpage_compact.sh create_webpage.sh README

	newinitd "${FILESDIR}"/${PN}-1.8.16-ipmievd.initd ipmievd
	newconfd "${FILESDIR}"/${PN}-1.8.16-ipmievd.confd ipmievd
	# TODO: init script for contrib/bmc-snmp-proxy
	# TODO: contrib/exchange-bmc-os-info
}
