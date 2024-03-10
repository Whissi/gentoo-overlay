# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

if [[ ${PV} == 9999* ]] ; then
	EGIT_REPO_URI="https://github.com/Whissi/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/Whissi/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
fi

DESCRIPTION="Intelligent background file updater utility"
HOMEPAGE="https://github.com/Whissi/ibfupdater"

LICENSE="GPL-3"
SLOT="0"

RDEPEND=">=app-shells/bash-4.2_p37
	>=net-misc/curl-7.26.0
	>=sys-apps/findutils-4.4.2
	>=sys-apps/coreutils-8.5
	>=sys-apps/util-linux-2.21"

DOCS=( README.md )

PATCHES=( "${FILESDIR}"/ibfupdater-0.10.0-bash-5.2.patch )

src_prepare() {
	if [[ ${PV} == 9999* ]] ; then
		einfo "Producing ChangeLog from Git history ..."
		pushd "${S}/.git" >/dev/null || die
		git log > "${S}"/ChangeLog || die
		popd >/dev/null || die
		DOCS=( "${DOCS[@]}" ChangeLog )
	fi

	default
}

src_install() {
	default
	dobin "${S}"/ibfupdater
}
