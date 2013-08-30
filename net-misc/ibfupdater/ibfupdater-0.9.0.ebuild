# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils

if [[ ${PV} == 9999* ]] ; then
	EGIT_REPO_URI="git://github.com/Whissi/${PN}.git
		https://github.com/Whissi/${PN}.git"
	inherit git-2
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/Whissi/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	RESTRICT="mirror"
	KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86"
fi

DESCRIPTION="Intelligent background file updater utility"
HOMEPAGE="https://github.com/Whissi/ibfupdater"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=">=app-shells/bash-4.2_p37
	>=net-misc/curl-7.26.0
	>=sys-apps/findutils-4.4.2
	>=sys-apps/coreutils-8.5
	>=sys-apps/util-linux-2.21"

src_prepare() {
	if [[ ${PV} == 9999* ]] ; then
		einfo "Producing ChangeLog from Git history ..."
		pushd "${S}/.git" >/dev/null || die
		git log > "${S}"/ChangeLog || die
		popd >/dev/null || die
	fi

	epatch_user
}

src_install() {
	dobin "${S}"/ibfupdater || die "dobin ibfupdater"

	if [[ ${PV} == 9999* ]] ; then
		dodoc ChangeLog || die "dodoc"
	fi
}
