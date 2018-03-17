# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools toolchain-funcs multilib-minimal

DESCRIPTION="Jemalloc is a general-purpose scalable concurrent allocator"
HOMEPAGE="http://www.canonware.com/jemalloc/"

PATCHES=( "${FILESDIR}/${PN}-4.5.0-fix_html_install.patch" )

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/jemalloc/jemalloc.git"
	DEPEND="dev-libs/libxslt"

	inherit git-r3
else
	SRC_URI="https://github.com/jemalloc/jemalloc/releases/download/${PV}/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"
	PATCHES=(
		"${FILESDIR}/${PN}-5.0.1-strip-optimization.patch"
	)
fi

LICENSE="BSD"
SLOT="0/2"
IUSE="debug hardened +hugepages lazy-lock static-libs stats xmalloc"
HTML_DOCS=( doc/jemalloc.html )
MULTILIB_WRAPPED_HEADERS=( /usr/include/jemalloc/jemalloc.h )
# autotools-utils.eclass auto-adds configure options when static-libs is in IUSE
# but jemalloc doesn't implement them in its configure; need this here to
# supress the warnings until automagic is removed from the eclass
QA_CONFIGURE_OPTIONS="--enable-static --disable-static --enable-shared --disable-shared"

src_prepare() {
	default

	sed -i \
		-e '/dnl Only optimize if not debugging./,/dnl Enable statistics calculation by default./ {/dnl Only optimize if not debugging./n;/dnl Enable statistics calculation by default./!d}' \
		-e '/\[-g3\]/d' \
		configure.ac || die "Failed to remove optimizations"

	eautoreconf
}

multilib_src_configure() {
	local myconf=()

	if use hardened ; then
		myconf+=( --disable-syscall )
	fi

	ECONF_SOURCE="${S}" \
	econf  \
		$(use_enable debug) \
		$(use_enable lazy-lock) \
		$(use_enable hugepages thp) \
		$(use_enable stats) \
		$(use_enable xmalloc) \
		"${myconf[@]}"
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
	use static-libs || find "${ED}" -name '*.a' -delete
}
