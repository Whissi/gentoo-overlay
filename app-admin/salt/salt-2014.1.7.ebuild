# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=(python{2_6,2_7})

inherit eutils distutils-r1 systemd

DESCRIPTION="Salt is a remote execution and configuration manager."
HOMEPAGE="http://saltstack.org/"

if [[ ${PV} == 9999* ]]; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/${PN}stack/${PN}.git"
	EGIT_BRANCH="develop"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~x86 ~amd64"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="ldap libcloud libvirt mako mongodb mysql openssl redis test +timelib"

RDEPEND="
	>=dev-python/pyzmq-2.2.0[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/m2crypto[${PYTHON_USEDEP}]
	dev-python/pycrypto[${PYTHON_USEDEP}]
	dev-python/pycryptopp[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/markupsafe[${PYTHON_USEDEP}]
	libcloud? ( >=dev-python/libcloud-0.14.0[${PYTHON_USEDEP}] )
	sys-apps/pciutils
	mako? ( dev-python/mako[${PYTHON_USEDEP}] )
	ldap? ( dev-python/python-ldap[${PYTHON_USEDEP}] )
	openssl? ( dev-python/pyopenssl[${PYTHON_USEDEP}] )
	libvirt? ( || (
		dev-python/libvirt-python[${PYTHON_USEDEP}]
		app-emulation/libvirt[python,${PYTHON_USEDEP}]
		)
	)
	mongodb? ( dev-python/pymongo[${PYTHON_USEDEP}] )
	mysql? ( dev-python/mysql-python[${PYTHON_USEDEP}] )
	redis? ( dev-python/redis-py[${PYTHON_USEDEP}] )
	timelib? ( dev-python/timelib[${PYTHON_USEDEP}] )
"
DEPEND="
	test? (
		dev-python/pip[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
		dev-python/SaltTesting[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/timelib[${PYTHON_USEDEP}]
		${RDEPEND}
	)
"

DOCS=(README.rst AUTHORS)

src_prepare() {
	epatch "${FILESDIR}"/${PVR}/10-tests-nonroot.patch
	epatch "${FILESDIR}"/${PVR}/20-minion-error.patch

	# this test fails because it trys to "pip install distribute"
	einfo "Removing unit tests for buildout module ..."
	rm tests/unit/{modules,states}/zcbuildout_test.py
}

python_install_all() {
	USE_SETUPTOOLS=1 distutils-r1_python_install_all

	for s in minion master syndic; do
		newinitd "${FILESDIR}"/${PVR}/initd.${s} salt-${s}
		newconfd "${FILESDIR}"/${PVR}/confd.${s} salt-${s}
		systemd_dounit "${FILESDIR}"/${PVR}/salt-${s}.service
	done

	insinto /etc/${PN}
	doins conf/*
}

python_test() {
	# testsuite likes lots of files
	ulimit -n 3072

	USE_SETUPTOOLS=1 SHELL="/bin/bash" TMPDIR=/tmp ./tests/runtests.py --unit-tests --no-report --verbose || die
}
