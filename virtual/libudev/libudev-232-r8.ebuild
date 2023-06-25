# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: 2bf61cd4815c4b10bc337f5651fb07dca6e0a3c4 $

EAPI=8

inherit multilib-build

DESCRIPTION="Virtual for libudev providers"

SLOT="0/1"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="systemd"

RDEPEND="
	!systemd? ( || (
		>=sys-fs/udev-250.4[${MULTILIB_USEDEP}]
		>=sys-fs/eudev-3.2.9:0/0[${MULTILIB_USEDEP}]
		sys-apps/systemd-utils[udev,${MULTILIB_USEDEP}]
	) )
	systemd? ( >=sys-apps/systemd-232:0/2[${MULTILIB_USEDEP}] )
"
