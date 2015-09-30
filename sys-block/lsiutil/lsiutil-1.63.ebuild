# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="LSI Logic Fusion MPT Command Line Interface management tool"
HOMEPAGE="http://www.lsi.com/"
SRC_URI="https://mirror.deutschmann.io/distfiles/lsi/LSIUTIL-${PV}.zip"

LICENSE="LSI"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ia64"
IUSE=""

RESTRICT="mirror bindist"

RDEPEND=""
DEPEND="app-arch/unzip"

QA_PRESTRIPPED="opt/lsi/${PN}/lsiutil"

S="${WORKDIR}/LSIUtil Kit ${PV}"

src_install() {
	exeinto /opt/lsi/${PN}

	if use x86; then
		doexe Linux/lsiutil || die
	elif use amd64; then
		newexe Linux/lsiutil.x86_64 lsiutil
	elif use ia64; then
		newexe Linux/lsiutil.ia64 lsiutil
	fi

	dosym /opt/lsi/${PN}/lsiutil /usr/sbin/lsiutil
}
