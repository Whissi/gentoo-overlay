# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION=" Stratum server implementation using Python Twisted"
HOMEPAGE="https://github.com/slush0/stratum"
LICENSE="GPL-3"
SLOT="0"

DEPEND="dev-python/autobahn[${PYTHON_USEDEP}]
	dev-python/ecdsa[${PYTHON_USEDEP}]
	dev-python/twisted-web[${PYTHON_USEDEP}]"

if [[ ${PV} == 9999* ]]; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/slush0/stratum/stratum.git"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~x86 ~amd64"
fi
