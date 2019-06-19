# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Send notifications when SSL certificates are about to expire"
HOMEPAGE="https://prefetch.net/articles/checkcertificate.html https://github.com/Matty9191/ssl-cert-check"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/Matty9191/${PN}.git"

	inherit git-r3
else
	MY_COMMIT="09fad650fb99ff8368d80d6a37d66faedda2abc8"
	SRC_URI="https://github.com/Matty9191/${PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}"/${PN}-${MY_COMMIT}

	PATCHES=(
		"${FILESDIR}"/${PN}-4.11-add-openssl-1-1-1-compat.patch
		"${FILESDIR}"/${PN}-4.11-fix-TLSFLAGS.patch
	)
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
