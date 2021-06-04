# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Type Hints for Python"
HOMEPAGE="https://docs.python.org/3/library/typing.html https://pypi.org/project/typing/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

src_prepare() {
	distutils-r1_src_prepare

	# broken on PyPy, unclear if CPython behavior is not a bug
	# https://github.com/python/typing/issues/671
	sed -i -e 's:test_new_no_args:_&:' python2/test_typing.py || die
}
