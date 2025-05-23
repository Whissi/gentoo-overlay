# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="systemd"
MY_PV="${PV/_/-}"

MINKV="3.11"
PYTHON_COMPAT=( python3_{10..13} )
inherit flag-o-matic meson python-any-r1

DESCRIPTION="Creates, deletes and cleans up volatile and temporary files and directories"
HOMEPAGE="https://systemd.io/"
SRC_URI="https://github.com/systemd/${MY_PN}/archive/v${MY_PV}.tar.gz -> ${MY_PN}-${MY_PV}.tar.gz"

LICENSE="BSD-2 GPL-2 LGPL-2.1 MIT public-domain"
SLOT="0"
if [[ ${PV} != *rc* ]] ; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi
IUSE="selinux test"
RESTRICT="!test? ( test )"

RDEPEND="
	sys-apps/acl:0=
	sys-libs/libcap:0=
	selinux? ( sys-libs/libselinux:0= )
	!sys-apps/opentmpfiles
	!sys-apps/systemd
	!sys-apps/systemd-utils[tmpfiles]
"

DEPEND="
	${RDEPEND}
	>=sys-kernel/linux-headers-${MINKV}
"

BDEPEND="
	$(python_gen_any_dep 'dev-python/jinja2[${PYTHON_USEDEP}]')
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	dev-util/gperf
	>=sys-apps/coreutils-8.16
	sys-devel/gettext
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

python_check_deps() {
	has_version -b "dev-python/jinja2[${PYTHON_USEDEP}]"
}

pkg_pretend() {
	if [[ -n ${EPREFIX} ]]; then
		ewarn "systemd-tmpfiles uses un-prefixed paths at runtime.".
	fi
}

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	local PATCHES=(
	)

	default

	# https://bugs.gentoo.org/767403
	python_fix_shebang src/test/*.py
	python_fix_shebang test/*.py
	python_fix_shebang tools/*.py
}

src_configure() {
	# disable everything until configure says "enabled features: ACL, tmpfiles, standalone-binaries, static-libsystemd(true)"
	# and optionally selinux feature can be enabled to make tmpfiles secontext-aware
	local systemd_disable_options=(
		adm-group
		analyze
		apparmor
		audit
		backlight
		binfmt
		blkid
		bzip2
		coredump
		dbus
		efi
		elfutils
		environment-d
		fdisk
		gcrypt
		glib
		gshadow
		gnutls
		hibernate
		hostnamed
		hwdb
		idn
		ima
		initrd
		firstboot
		kernel-install
		kmod
		ldconfig
		libcryptsetup
		libcurl
		libfido2
		libidn
		libidn2
		libiptc
		link-networkd-shared
		link-systemctl-shared
		link-timesyncd-shared
		link-udev-shared
		localed
		logind
		lz4
		machined
		microhttpd
		networkd
		nscd
		nss-myhostname
		nss-resolve
		nss-systemd
		oomd
		openssl
		p11kit
		pam
		pcre2
		polkit
		portabled
		pstore
		pwquality
		randomseed
		resolve
		rfkill
		seccomp
		smack
		sysext
		sysusers
		tests
		timedated
		timesyncd
		tpm
		tpm2
		qrencode
		quotacheck
		userdb
		utmp
		vconsole
		wheel-group
		xdg-autostart
		xkbcommon
		xz
		zlib
		zstd
	)

	# prepend -D and append =false, e.g. zstd becomes -Dzstd=false
	systemd_disable_options=( ${systemd_disable_options[@]/#/-D} )
	systemd_disable_options=( ${systemd_disable_options[@]/%/=false} )

	local emesonargs=(
		-Drootprefix="${EPREFIX:-/}"
		-Dacl=true
		-Dtmpfiles=true
		-Dstandalone-binaries=true # this and below option does the magic
		-Dstatic-libsystemd=true
		-Dsysvinit-path=''
		${systemd_disable_options[@]}
		$(meson_use selinux)
	)
	meson_src_configure
}

src_compile() {
	# tmpfiles and sysusers can be built as standalone and link systemd-shared in statically.
	# https://github.com/systemd/systemd/pull/16061 original implementation
	# we just need to pass -Dstandalone-binaries=true and
	# use <name>.standalone target below.
	# check meson.build for if have_standalone_binaries condition per target.
	local mytargets=(
		systemd-tmpfiles.standalone
		man/tmpfiles.d.5
		man/systemd-tmpfiles.8
	)
	meson_src_compile "${mytargets[@]}"
}

src_install() {
	# lean and mean installation, single binary and man-pages
	pushd "${BUILD_DIR}" > /dev/null || die
	into /
	newbin systemd-tmpfiles.standalone systemd-tmpfiles

	doman man/{systemd-tmpfiles.8,tmpfiles.d.5}

	popd > /dev/null || die

	# service files adapter from opentmpfiles
	newinitd "${FILESDIR}"/stmpfiles-dev.initd stmpfiles-dev
	newinitd "${FILESDIR}"/stmpfiles-setup.initd stmpfiles-setup

	# same content, but install as different file
	newconfd "${FILESDIR}"/stmpfiles.confd stmpfiles-dev
	newconfd "${FILESDIR}"/stmpfiles.confd stmpfiles-setup
}

src_test() {
	# 'meson test' will compile full systemd, but we can still outsmart it
	"${EPYTHON}" test/test-systemd-tmpfiles.py \
		"${BUILD_DIR}"/systemd-tmpfiles.standalone || die "${FUNCNAME} failed"
}

# stolen from opentmpfiles ebuild
add_service() {
	local initd=$1
	local runlevel=$2

	elog "Auto-adding '${initd}' service to your ${runlevel} runlevel"
	mkdir -p "${EROOT}/etc/runlevels/${runlevel}"
	ln -snf "${EPREFIX}/etc/init.d/${initd}" "${EROOT}/etc/runlevels/${runlevel}/${initd}"
}

pkg_postinst() {
	if [[ -z $REPLACING_VERSIONS ]]; then
		add_service stmpfiles-dev sysinit
		add_service stmpfiles-setup boot
	fi
}
