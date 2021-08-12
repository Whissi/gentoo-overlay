# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# DO NOT ADD pypy to PYTHON_COMPAT
# pypy bundles a modified version of cffi. Use python_gen_cond_dep instead.
PYTHON_COMPAT=( python2_7 python3_{7..10} )

inherit distutils-r1 toolchain-funcs

DESCRIPTION="Foreign Function Interface for Python calling C code"
HOMEPAGE="https://cffi.readthedocs.io/ https://pypi.org/project/cffi/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="test"

DEPEND="dev-libs/libffi:="
RDEPEND="${DEPEND}
	dev-python/pycparser[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}
	virtual/pkgconfig"

distutils_enable_sphinx doc/source

PATCHES=(
	"${FILESDIR}"/cffi-1.14.0-darwin-no-brew.patch
)

src_prepare() {
	if [[ ${CHOST} == *darwin* ]] ; then
		# Don't obsessively try to find libffi
		sed -i -e "s/.*\-iwithsysroot\/usr\/include\/ffi.*/\tpass/" setup.py || die
	fi
	distutils-r1_src_prepare
}

src_configure() {
	tc-export PKG_CONFIG
}

python_test() {
	"${EPYTHON}" -c "import _cffi_backend as backend" || die
	epytest \
		--ignore testing/test_zintegration.py \
		--ignore testing/embedding \
		c/ testing/
}
