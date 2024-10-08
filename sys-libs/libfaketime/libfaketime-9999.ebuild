# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit flag-o-matic toolchain-funcs multilib-minimal

DESCRIPTION="Report faked system time to programs"
HOMEPAGE="http://www.code-wizards.com/projects/libfaketime/ https://github.com/wolfcw/libfaketime"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/wolfcw/${PN}.git"

	inherit git-r3
else
	SRC_URI="https://github.com/wolfcw/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~sparc ~x86"
fi

LICENSE="GPL-2"
SLOT="0"

src_prepare() {
	default

	sed -i 's/-Werror //' "${S}"/{src,test}/Makefile || die

	# Bug #617624 (GCC-6 compatibility)
	sed -i 's/-Wno-nonnull-compare //' "${S}"/src/Makefile || die

	# bug #863911
	filter-lto

	# We used to always set this, but see:
	# 1. https://github.com/wolfcw/libfaketime/commit/40edcc7ca087a8118fe5a2d27152617fa233e0e2
	#     i.e. we should report cases which end up needing it, rather than always setting it.
	#
	# 2. As of 0.9.10, libfaketime tries to detect at runtime if it's needed.
	#append-cflags -DFORCE_MONOTONIC_FIX

	# bug #844958
	use riscv && append-cflags -DFORCE_PTHREAD_NONVER

	# bug #908668
	use elibc_musl && append-cppflags -D_LARGEFILE64_SOURCE

	multilib_copy_sources
}

multilib_src_compile() {
	local target=all

	pushd src > /dev/null || die
	multilib_is_native_abi || target="${PN}.so.1 ${PN}MT.so.1"
	# ${target} is intentionally not quoted
	emake CC="$(tc-getCC)" LIBDIRNAME="/$(get_libdir)" PREFIX=/usr ${target}
	popd > /dev/null || die
}

multilib_src_test() {
	multilib_is_native_abi && emake CC="$(tc-getCC)" test
}

multilib_src_install() {
	multilib_is_native_abi && dobin src/faketime

	exeinto /usr/$(get_libdir)
	doexe src/${PN}*.so.*

	dosym ${PN}.so.1 /usr/$(get_libdir)/${PN}.so
	dosym ${PN}MT.so.1 /usr/$(get_libdir)/${PN}MT.so
}

multilib_src_install_all() {
	doman man/faketime.1
	dodoc NEWS README TODO
}
