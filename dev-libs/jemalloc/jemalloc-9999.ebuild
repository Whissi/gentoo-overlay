# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit autotools multilib-minimal

DESCRIPTION="Jemalloc is a general-purpose scalable concurrent allocator"
HOMEPAGE="http://jemalloc.net/ https://github.com/jemalloc/jemalloc"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/jemalloc/jemalloc.git"
	DEPEND="dev-libs/libxslt"

	inherit git-r3
else
	SRC_URI="https://github.com/jemalloc/jemalloc/releases/download/${PV}/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"
	PATCHES=(
		"${FILESDIR}/${PN}-5.3.0-gentoo-fixups.patch"
		"${FILESDIR}/${PN}-5.3.0-backport-pr-2312.patch"
		"${FILESDIR}/${PN}-5.3.0-backport-pr-2338.patch"
	)
fi

LICENSE="BSD"
SLOT="0/2"
IUSE="debug lazy-lock prof stats stats xmalloc"
HTML_DOCS=( doc/jemalloc.html )

MULTILIB_WRAPPED_HEADERS=( /usr/include/jemalloc/jemalloc.h )

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	local myconf=(
		$(use_enable debug)
		$(use_enable lazy-lock)
		$(use_enable prof)
		$(use_enable stats)
		$(use_enable xmalloc)
	)

	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_compile() {
	default

	if [[ ${PV} == "9999" ]] && multilib_is_native_abi; then
		emake build_doc
	fi
}

multilib_src_install() {
	# Copy man file which the Makefile looks for
	if [[ -f "${S}/doc/jemalloc.3" ]]; then
		cp "${S}/doc/jemalloc.3" "${BUILD_DIR}/doc" || die
	fi
	emake DESTDIR="${D}" install
}

multilib_src_install_all() {
	if [[ ${CHOST} == *-darwin* ]] ; then
		# fixup install_name, #437362
		install_name_tool \
			-id "${EPREFIX}"/usr/$(get_libdir)/libjemalloc.2.dylib \
			"${ED}"/usr/$(get_libdir)/libjemalloc.2.dylib || die
	fi
	find "${ED}" -name '*.a' -delete || die
}
