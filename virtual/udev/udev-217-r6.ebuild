# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: 72c317f8976ff0f1cdc3de040d4d725c68243397 $

EAPI=8

DESCRIPTION="Virtual to select between different udev daemon providers"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="systemd"

RDEPEND="
	systemd? ( >=sys-apps/systemd-217 )
	!systemd? (
		|| (
			>=sys-fs/udev-250.4
			>=sys-fs/eudev-2.1.1
			sys-apps/systemd-utils[udev]
		)
	)
"
