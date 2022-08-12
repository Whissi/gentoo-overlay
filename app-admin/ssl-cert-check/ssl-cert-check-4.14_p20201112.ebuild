# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Send notifications when SSL certificates are about to expire"
HOMEPAGE="https://prefetch.net/articles/checkcertificate.html https://github.com/Matty9191/ssl-cert-check"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/Matty9191/${PN}.git"

	inherit git-r3
else
	MY_COMMIT="4056ceeab5abc0e39f4e0ea40cd54147253a3369"
	SRC_URI="https://github.com/Matty9191/${PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}"/${PN}-${MY_COMMIT}
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="dev-libs/openssl:*"
DEPEND=""

src_install() {
	local DOCS=(
		README.md
	)

	default

	dobin ssl-cert-check
}
