# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils linux-info linux-mod

DESCRIPTION="Kernel module for Realtek 8111/8168 PCI-E NICs"
HOMEPAGE="http://www.realtek.com.tw"
SRC_URI="http://mirror.whissi.de/distfiles/${PN}/r8168-${PV}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="virtual/linux-sources"
RDEPEND=""

S="${WORKDIR}"/r8168-${PV}

pkg_pretend() {
	if use kernel_linux && linux_config_exists ; then
		einfo "Kernel configuration detected, I will do some checks, now."

		ebegin "Checking that Realtek RTL8169 support isn't built-in into the kernel"
		if ! linux_chkconfig_builtin R8169 ; then
			eend 0
		else
			eend 1

			ewarn ""
			ewarn "You have the Realtek RTL8169 support built-in into your kernel."
			ewarn "This will prevent you from using the r8168 driver."
			ewarn ""
			ewarn "If you want to keep the r8169 support as fallback, you should"
			ewarn "add it as module."
			ewarn ""
		fi
	else
		ewarn ""
		ewarn "You are not using a Linux kernel or I was unable to detect your kernel"
		ewarn "configuration file."
		ewarn ""
		ewarn "You might have some incompatible kernel options enabled."
		ewarn ""
	fi
}

pkg_setup() {
	linux-mod_pkg_setup

	MODULE_NAMES="r8168(kernel/drivers/net:"${S}":src)"
	BUILD_TARGETS="modules"
	BUILD_PARAMS="\
		KERNELDIR=\"${KV_DIR}\""
}

src_prepare() {
	convert_to_m "${S}/src/Makefile"
}

pkg_postinst() {
	linux-mod_pkg_postinst

	if use kernel_linux && linux_config_exists ; then
		if linux_chkconfig_module R8169 ; then
			elog ""
			elog "The r8169 module was detected. Please be aware, that this module"
			elog "will block the r8168 module."
			elog ""
			elog "Blacklisting the r8169 module is highly recommended!"
			elog ""
		fi

		local check=`lsmod | grep r8169`
		if [ "$check" != "" ] ; then
			einfo "To start using the new r8168 module, you first have to"
			einfo "unload the currently loaded r8169 module:"
			einfo ""
			einfo "  # rmmod r8169"
			einfo "  # modprobe r8168"
			einfo ""
			einfo "Warning:"
			einfo "Remember, that unloading the module might kill your network."
			einfo "If you have SSHed into this machine, you should switch the module"
			einfo "by doing a reboot."
		else
			einfo "To start using the new r8168 module, just type"
			einfo ""
			einfo "  # modprobe r8168"
			einfo ""
			einfo "This will load the module."
		fi
	fi
}

pkg_postrm() {
	linux-mod_pkg_postrm

	if use kernel_linux && linux_config_exists ; then
		if linux_chkconfig_module R8169 ; then
			elog ""
			elog "Remember to undo the r8169 blacklisting!"
		fi
	fi
}
