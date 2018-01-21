# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit eutils

if [[ ${PV} == 9999* ]] ; then
	EGIT_REPO_URI="https://github.com/Whissi/${PN}.git"
	inherit git-r3
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/Whissi/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	RESTRICT="mirror"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="ipset update utility"
HOMEPAGE="https://github.com/Whissi/update-ipset"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DOCS=( README.md )

DEPEND=""
RDEPEND=">=app-shells/bash-4.2_p37
	>=net-firewall/ipset-6.15
	>=sys-apps/findutils-4.4.2
	>=sys-apps/grep-2.9
	>=sys-apps/coreutils-8.5
	>=sys-apps/util-linux-2.21"

src_prepare() {
	default

	if [[ ${PV} == 9999* ]] ; then
		einfo "Producing ChangeLog from Git history ..."
		pushd "${S}/.git" >/dev/null || die
		git log > "${S}"/ChangeLog || die
		popd >/dev/null || die
		DOCS=( "${DOCS[@]}" ChangeLog )
	fi
}

src_install() {
	dosbin "${S}"/update-ipset
	dodoc "${DOCS[@]}"
}
