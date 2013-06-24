# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils multilib

MY_P="${PN}_${PV}"
DESCRIPTION="Library for build EFI Applications"
HOMEPAGE="http://developer.intel.com/technology/efi"
SRC_URI="mirror://sourceforge/gnu-efi/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE=""

DEPEND="sys-apps/pciutils"
RDEPEND=""

S=${WORKDIR}/${P%?}

# These objects get run early boot (i.e. not inside of Linux),
# so doing these QA checks on them doesn't make sense.
QA_EXECSTACK="usr/*/lib*efi.a:* usr/*/crt*.o"

src_compile() {
	emake PREFIX="${EPREFIX}/usr" || die "gnu efi: make failed"
}

src_install() {
	emake PREFIX="${EPREFIX}/usr" INSTALLROOT="${D}" install || die "gnu-efi: install failed"
	dodoc README* ChangeLog
}
