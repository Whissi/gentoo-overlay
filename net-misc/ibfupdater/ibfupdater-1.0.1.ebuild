# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PYTHON_COMPAT=( python3_{12..14} )

inherit python-any-r1

if [[ ${PV} == 9999* ]] ; then
	EGIT_REPO_URI="https://github.com/Whissi/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/Whissi/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
fi

DESCRIPTION="Intelligent background file updater utility"
HOMEPAGE="https://github.com/Whissi/ibfupdater"

LICENSE="GPL-3"
SLOT="0"

IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=app-shells/bash-4.2_p37
	>=net-misc/curl-7.26.0
	>=sys-apps/findutils-4.4.2
	>=sys-apps/coreutils-8.5
	sys-apps/diffutils
	>=sys-apps/util-linux-2.21"

BDEPEND="test? (
	${PYTHON_DEPS}
	${RDEPEND}
)"

DOCS=( README.md )

pkg_setup() {
	if use test; then
		python-any-r1_pkg_setup
	fi
}

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

src_test() {
	TMPDIR="${T}" "${PYTHON}" tests/integration.py -v \
		|| die "Integration tests failed"
}

src_install() {
	default
	dobin "${S}"/ibfupdater
}
