# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: a783e042240da449d02feb55ad5a9a2d76ce5915 $

EAPI=8

DESCRIPTION="Virtual to select between different tmpfiles.d handlers"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="systemd"

RDEPEND="
	kernel_linux? (
		!prefix-guest? (
			systemd? ( sys-apps/systemd )
			!systemd? (
				|| (
					sys-apps/seedfiles
					>=sys-apps/systemd-tmpfiles-250.4
					sys-apps/systemd-utils[tmpfiles]
				)
			)
		)
	)
"
