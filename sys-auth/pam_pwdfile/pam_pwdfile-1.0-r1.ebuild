# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="7"

inherit flag-o-matic

DESCRIPTION="PAM module for authenticating against passwd-like files."
HOMEPAGE="http://cpbotha.net/pam_pwdfile.html"
SRC_URI="https://github.com/tiwe-de/libpam-pwdfile/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

DEPEND="virtual/libcrypt"
RDEPEND="virtual/libcrypt:="

S="${WORKDIR}/${P/pam_/libpam-}"

DOCS=( README changelog )

src_configure() {
	append-cppflags -Wall -Wformat-security -D_BSD_SOURCE
}
