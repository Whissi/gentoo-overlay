# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit

DESCRIPTION="Tool for editing VCS repositories and translating among different systems"
HOMEPAGE="http://www.catb.org/~esr/reposurgeon/"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://gitlab.com/esr/reposurgeon.git"

	inherit git-r3
else
	SRC_URI="http://www.catb.org/~esr/${PN}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD-2"
SLOT="0"

IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}
	virtual/pkgconfig
	app-text/xmlto
	app-text/asciidoc"

#DOCS=( README.md CONFIGURATION.md INTRODUCTION.md LICENSE LICENSE.pycrc LICENSE.snappy )

src_install() {
	emake DESTDIR="${D%/}" prefix="/usr" install
}