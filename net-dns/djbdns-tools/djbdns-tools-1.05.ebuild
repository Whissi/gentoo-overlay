# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

MY_PN="djbdns"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Collection of djbdns tools (no server!)"
HOMEPAGE="https://cr.yp.to/djbdns.html"
IPV6_PATCH="test27"

SRC_URI="http://cr.yp.to/djbdns/${MY_P}.tar.gz
	http://smarden.org/pape/djb/manpages/${MY_P}-man.tar.gz
	ipv6? ( http://www.fefe.de/dns/${MY_P}-${IPV6_PATCH}.diff.bz2 )"

SLOT="0"
LICENSE="public-domain"
KEYWORDS="~amd64 ~x86"
IUSE="ipv6"

DEPEND="!net-dns/djbdns"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

src_unpack(){
	# Unpack both djbdns and its man pages to separate directories.
	default

	# Now move the man pages under ${S} so that user patches can be
	# applied to them as well in src_prepare().
	mv "${MY_PN}-man" "${MY_P}/man" || die "failed to transplant man pages"
}

src_prepare() {
	eapply -p2 "${FILESDIR}/headtail.patch"
	eapply "${FILESDIR}/dnsroots.patch" \
		"${FILESDIR}/dnstracesort.patch" \
		"${FILESDIR}/string_length_255.patch" \
		"${FILESDIR}/srv_record_support.patch"

	# Fix CVE2009-0858
	eapply "${FILESDIR}/CVE2009-0858_0001-check-response-domain-name-length.patch"

	if use ipv6; then
		elog 'At present dnstrace does NOT support IPv6. It will'\
			 'be compiled without IPv6 support.'

		# Create a separate copy of the source tree for dnstrace.
		cp -pR "${S}" "${S}-noipv6" || die

		# The big ipv6 patch.
		eapply "${WORKDIR}/${MY_P}-${IPV6_PATCH}.diff"

		# Fix CVE2008-4392 (ipv6)
		eapply \
			"${FILESDIR}/CVE2008-4392_0001-dnscache-merge-similar-outgoing-queries-ipv6-test25.patch" \
			"${FILESDIR}/CVE2008-4392_0002-dnscache-cache-soa-records-ipv6.patch" \
			"${FILESDIR}/makefile-parallel-test25.patch"

		cd "${S}-noipv6" || die
	fi

	# Fix CVE2008-4392 (no ipv6)
	eapply \
		"${FILESDIR}/CVE2008-4392_0001-dnscache-merge-similar-outgoing-queries.patch" \
		"${FILESDIR}/CVE2008-4392_0002-dnscache-cache-soa-records.patch"

	# Later versions of the ipv6 patch include this, but even if
	# USE=ipv6, we're in the ${S}-noipv6 directory at this point.
	eapply -p0 "${FILESDIR}/${PV}-errno.patch"

	einfo "Removing unused man pages ..."
	rm -f man/{}

	eapply_user
}

src_compile() {
	echo "$(tc-getCC) ${CFLAGS}" > conf-cc || die
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld || die
	echo "/usr" > conf-home || die
	emake

	# If djbdns is compiled with IPv6 support, it breaks dnstrace.
	# Therefore we must compile dnstrace separately without IPv6
	# support.
	if use ipv6; then
		elog 'Compiling dnstrace without ipv6 support'
		cp conf-cc conf-ld conf-home "${S}-noipv6/" || die
		cd "${S}-noipv6" || die
		emake dnstrace
	fi
}

src_install() {
	local bins_ipv4="axfr-get tinydns-data tinydns-get"
	bins_ipv4+=" dnsip dnsipq dnsname dnstxt dnsmx"
	bins_ipv4+=" dnsfilter random-ip dnsqr dnsq dnstrace dnstracesort"

	local man_pages="axfr-get tinydns-data tinydns-get"
	man_pages+=" dnsip dnsipq dnsname dnstxt dnsmx"
	man_pages+=" dnsfilter dnsqr dnsq dnstrace dnstracesort"

	into /usr
	dobin ${bins_ipv4}

	for man_page in ${man_pages}; do
		doman man/${man_page}.*
	done

	if use ipv6; then
		dobin dnsip6 dnsip6q "${S}-noipv6/dnstrace"
	fi

	dodoc CHANGES README
}
