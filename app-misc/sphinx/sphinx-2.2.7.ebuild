# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils autotools toolchain-funcs

#MY_P=${P/_/-}
MY_P=${P}-release

DESCRIPTION="Full-text search engine with support for MySQL and PostgreSQL"
HOMEPAGE="http://www.sphinxsearch.com/"
SRC_URI="http://sphinxsearch.com/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +iconv +id64 +mysql odbc postgres re2 stemmer +syslog test +xml"
RESTRICT="!test? ( test )"

RDEPEND="
	mysql? ( virtual/mysql )
	postgres? ( >=dev-db/postgresql-8.4.20 )
	odbc? ( dev-db/unixODBC )
	re2? ( >=dev-libs/re2-0_p20140304 )
	stemmer? ( dev-libs/snowball-stemmer )
	syslog? ( virtual/logger )
	xml? ( dev-libs/expat )
	iconv? ( virtual/libiconv )
"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.0.1_beta-darwin8.patch

	# drop nasty hardcoded search path breaking Prefix
	# We patch configure directly since otherwise we need to run
	# eautoreconf twice and that causes problems, bug 425380
	sed -i -e 's/\/usr\/local\//\/someplace\/nonexisting\//g' configure || die

	# Fix QA compilation warnings.
	sed -i -e '19i#include <string.h>' api/libsphinxclient/test.c || die

	pushd api/libsphinxclient || die
	mv configure.in configure.ac || die "Failed to rename configure.in!"
	eautoreconf
	popd || die
}

src_configure() {
	# fix libiconv detection
	use !elibc_glibc && export ac_cv_search_iconv=-liconv

	econf \
		--sysconfdir="${EPREFIX}/etc/${PN}" \
		$(use_enable id64) \
		$(use_with debug) \
		$(use_with iconv) \
		$(use_with mysql) \
		$(use_with odbc unixodbc) \
		$(use_with postgres pgsql) \
		$(use_with re2 ) \
		$(use_with stemmer libstemmer) \
		$(use_with syslog syslog) \
		$(use_with xml libexpat ) \
		--without-rlp

	cd api/libsphinxclient || die
	econf STRIP=:
}

src_compile() {
	emake AR="$(tc-getAR)" || die "emake failed"

	emake -j 1 -C api/libsphinxclient || die "emake libsphinxclient failed"
}

src_test() {
	elog "Tests require access to a live MySQL database and may require configuration."
	elog "You will find them in /usr/share/${PN}/test and they require dev-lang/php"
}

src_install() {
	emake DESTDIR="${D%/}" install || die "install failed"
	emake DESTDIR="${D%/}" -C api/libsphinxclient install || die "install libsphinxclient failed"

	dodoc doc/*

	dodir /var/lib/sphinx
	dodir /var/log/sphinx

	newinitd "${FILESDIR}"/searchd.initd searchd
	newconfd "${FILESDIR}"/searchd.confd searchd

	if use test; then
		insinto /usr/share/${PN}
		doins -r test
	fi
}
