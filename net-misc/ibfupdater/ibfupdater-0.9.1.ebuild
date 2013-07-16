# Copyright 2013-2013 Thomas D.
# Distributed under the terms of the GNU General Public License v3 (or later)

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
	KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86"
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

DOCS=( README.md )

src_prepare() {
	if [[ ${PV} == 9999* ]] ; then
		einfo "Producing ChangeLog from Git history ..."
		pushd "${S}/.git" >/dev/null || die
		git log > "${S}"/ChangeLog || die
		popd >/dev/null || die
		DOCS=( "${DOCS[@]}" ChangeLog )
	fi
	
	epatch_user
}

src_install() {
	dobin "${S}"/ibfupdater
	dodoc "${DOCS[@]}"
}
