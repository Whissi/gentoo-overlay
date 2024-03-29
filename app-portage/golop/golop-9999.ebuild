# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
EGO_PN=github.com/klausman/golop

if [[ ${PV} = 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://${EGO_PN}.git"
else
	KEYWORDS="~amd64 ~x86"
	EGIT_COMMIT=v${PV}
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi

inherit golang-build prefix

DESCRIPTION="A pure Go re-implementation of genlop"
HOMEPAGE="https://github.com/klausman/golop"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
DEPEND=""
RDEPEND=""

src_prepare() {
	sed -i -e 's@/var/log/emerge.log@'"${EPREFIX}"'&@g' "${S}"/main.go || die
	default
}

src_install() {
	dobin ${PN}

	declare -a DOCS
	DOCS+=( "${S}"/README.md )
	einstalldocs
}
