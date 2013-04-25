# Copyright 2013 Thomas D.
# Distributed under the terms of the GNU General Public License v3 (or later)

EAPI="4"

inherit eutils

if [[ ${PV} == 9999* ]] ; then
	EGIT_REPO_URI="git://github.com/Whissi/${PN}.git
		https://github.com/Whissi/${PN}.git"
	inherit git-2
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/Whissi/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86"
fi

DESCRIPTION="ipset update utility"
HOMEPAGE="https://github.com/Whissi/update-ipset"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=">=app-shells/bash-4.2_p37
	>=net-firewall/ipset-6.15
	>=sys-apps/findutils-4.4.2
	>=sys-apps/grep-2.9
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
	dosbin "${S}"/update-ipset || die "dosbin update-ipset"
	
	if [[ ${PV} == 9999* ]] ; then
		dodoc ChangeLog || die "dodoc"
	fi
}
