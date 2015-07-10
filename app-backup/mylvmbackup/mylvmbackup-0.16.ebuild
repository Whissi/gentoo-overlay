# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="mylvmbackup is a tool for quickly creating backups of MySQL server's data files using LVM snapshots"
HOMEPAGE="http://lenzg.net/mylvmbackup/"
SRC_URI="http://lenzg.net/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="snmp"
DEPEND=""
RDEPEND="dev-perl/Config-IniFiles
		>=sys-fs/lvm2-2.02.06
		dev-perl/DBD-mysql
		virtual/mysql
		dev-perl/TimeDate
		dev-perl/File-Copy-Recursive
		snmp? ( dev-perl/Net-SNMP )"

src_prepare() {
	sed -i \
		-e '/^prefix/s,/usr/local,/usr,' \
		"${S}"/Makefile || die

	sed -i 's|mycnf=/etc/my.cnf|mycnf=/etc/mysql/my.cnf|' \
		"${S}"/mylvmbackup.conf || die
}

src_install() {
	emake install DESTDIR="${D%/}" mandir="/usr/share/man"
	dodoc ChangeLog README TODO
	keepdir /var/tmp/${PN}/{backup,mnt}
	fperms 0700 /var/tmp/${PN}/
}
