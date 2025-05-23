# Copyright 2003-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..13} )

inherit bash-completion-r1 flag-o-matic linux-info meson-multilib ninja-utils python-single-r1 toolchain-funcs udev usr-ldscript

if [[ ${MY_PV} = 9999* ]] ; then
	EGIT_REPO_URI="https://github.com/systemd/systemd.git"
	inherit git-r3
else
	MY_PN=systemd
	MY_PV="${PV/_/-}"
	MY_P="${MY_PN}-${MY_PV}"
	S="${WORKDIR}/${MY_P}"
	SRC_URI="https://github.com/systemd/${MY_PN}/archive/v${MY_PV}/${MY_P}.tar.gz"

	# musl patches taken from:
	# http://cgit.openembedded.org/openembedded-core/tree/meta/recipes-core/systemd/systemd
	MUSL_PATCHSET="systemd-musl-patches-255.6"
	SRC_URI+="
		elibc_musl? (
			https://dev.gentoo.org/~floppym/dist/${MUSL_PATCHSET}.tar.gz
	)"

	if [[ ${PV} != *_rc* ]] ; then
		KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
	fi

	SPLIT_USR_PATCH='systemd-257-split_usr.patch'
	FIXUP_PATCH="${PN}-257.1-revert-systemd-messup.patch"
	SRC_URI+="
		https://www.gentoofan.org/gentoo/dist/${SPLIT_USR_PATCH}.xz
		https://www.gentoofan.org/gentoo/dist/${FIXUP_PATCH}.xz
	"
fi

DESCRIPTION="Linux dynamic and persistent device naming support (aka userspace devfs)"
HOMEPAGE="https://systemd.io/"

LICENSE="LGPL-2.1 MIT GPL-2"
SLOT="0"
IUSE="acl +kmod selinux test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

BDEPEND="
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	dev-util/gperf
	>=sys-apps/coreutils-8.16
	sys-devel/gettext
	virtual/pkgconfig
	$(python_gen_cond_dep 'dev-python/jinja2[${PYTHON_USEDEP}]')
	test? (
		app-text/tree
		dev-lang/perl
	)
"
COMMON_DEPEND="
	dev-libs/openssl:0=[${MULTILIB_USEDEP}]
	>=sys-apps/util-linux-2.32:0[${MULTILIB_USEDEP}]
	sys-libs/libcap:0=[${MULTILIB_USEDEP}]
	virtual/libcrypt:=[${MULTILIB_USEDEP}]
	acl? ( sys-apps/acl:0= )
	kmod? ( >=sys-apps/kmod-15:0= )
	selinux? ( >=sys-libs/libselinux-2.1.9:0= )
"
DEPEND="${COMMON_DEPEND}
	>=sys-kernel/linux-headers-3.9
"
RDEPEND="${COMMON_DEPEND}
	acct-group/audio
	acct-group/cdrom
	acct-group/dialout
	acct-group/disk
	acct-group/floppy
	acct-group/input
	acct-group/kmem
	acct-group/kvm
	acct-group/lp
	acct-group/render
	acct-group/sgx
	acct-group/tape
	acct-group/tty
	acct-group/usb
	acct-group/video
	!sys-apps/gentoo-systemd-integration
	!sys-apps/systemd
	!sys-apps/systemd-utils[udev]
	!sys-apps/hwids[udev]
"
PDEPEND="
	>=sys-fs/udev-init-scripts-34
"

pkg_setup() {
	if [[ ${MERGE_TYPE} != buildonly ]] ; then
		CONFIG_CHECK="~BLK_DEV_BSG ~DEVTMPFS ~!IDE ~INOTIFY_USER ~!SYSFS_DEPRECATED ~!SYSFS_DEPRECATED_V2 ~SIGNALFD ~EPOLL ~FHANDLE ~NET ~!FW_LOADER_USER_HELPER ~UNIX"
		linux-info_pkg_setup

		# CONFIG_FHANDLE was introduced by 2.6.39
		local MINKV=2.6.39

		if kernel_is -lt ${MINKV//./ } ; then
			eerror "Your running kernel is too old to run this version of ${MY_P}"
			eerror "You need to upgrade kernel at least to ${MINKV}"
		fi

		if kernel_is -lt 3 7 ; then
			ewarn "Your running kernel is too old to have firmware loader and"
			ewarn "this version of ${MY_P} doesn't have userspace firmware loader"
			ewarn "If you need firmware support, you need to upgrade kernel at least to 3.7"
		fi
	fi
}

src_prepare() {
	if [[ -d "${WORKDIR}/patches" ]] ; then
		eapply "${WORKDIR}/patches"
	fi

	local PATCHES=(
	)
	use elibc_musl && PATCHES+=( "${WORKDIR}/${MUSL_PATCHSET}" )

	default

	eapply "${WORKDIR}"/${SPLIT_USR_PATCH}
	eapply "${WORKDIR}"/${FIXUP_PATCH}
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_native_use_feature acl)
		-Defi=false
		$(meson_native_use_feature kmod)
		$(meson_native_use_feature selinux)
		-Dlink-udev-shared=false
		-Dsplit-usr=true
		-Drootlibdir="${EPREFIX}/usr/$(get_libdir)"

		# Prevent automagic deps
		-Dgcrypt=disabled
		-Dlibcryptsetup=disabled
		-Dlibfido2=disabled
		-Didn=false
		-Dlibidn=disabled
		-Dlibidn2=disabled
		-Dlibiptc=disabled
		-Dlogind=false
		-Dp11kit=disabled
		-Dseccomp=disabled
		-Dlz4=disabled
		-Dxz=disabled
	)
	use elibc_musl && emesonargs+=(
		-Dgshadow=false
		-Dsmack=false
		-Dutmp=false
	)

	meson_src_configure
}

src_configure() {
	# Prevent conflicts with i686 cross toolchain, bug 559726
	tc-export AR CC NM OBJCOPY RANLIB
	python_setup

	use elibc_musl && append-cppflags -D__UAPI_DEF_ETHHDR=0

	multilib-minimal_src_configure
}

have_dmi() {
	case ${CHOST} in
		aarch64*|arm*|ia64*|i?86*|loongarch64*|mips*|x86_64*)
			return 0 ;;
	esac
	return 1
}

multilib_src_compile() {
	# meson creates this link
	local libudev=$(readlink libudev.so.1)

	local targets=(
		${libudev}
		src/libudev/libudev.pc
	)
	if multilib_is_native_abi ; then
		targets+=(
			udevd
			udevadm
			ata_id
			cdrom_id
			fido_id
			iocost
			mtd_probe
			scsi_id
			v4l_id
			src/udev/udev.pc
			man/libudev.3
			man/udev_device_get_syspath.3
			man/udev_device_has_tag.3
			man/udev_device_new_from_syspath.3
			man/udev_enumerate_add_match_subsystem.3
			man/udev_enumerate_new.3
			man/udev_enumerate_scan_devices.3
			man/udev_list_entry.3
			man/udev_monitor_filter_update.3
			man/udev_monitor_new_from_netlink.3
			man/udev_monitor_receive_device.3
			man/udev_new.3
			man/udev.conf.5
			man/udev.link.5
			man/udev.7
			man/udevd.8
			man/udevadm.8
			hwdb.d/60-autosuspend-chromiumos.hwdb
			rules.d/50-udev-default.rules
			rules.d/60-persistent-storage.rules
			rules.d/64-btrfs.rules
			# installed by sys-auth/elogind
			#rules.d/70-uaccess.rules
			#rules.d/71-seat.rules
			#rules.d/73-seat-late.rules
			#rules.d/99-systemd.rules
		)
		if have_dmi; then
			targets+=( dmi_memory_id )
		fi
		# former USE="hwdb"
		targets+=(
			udev-hwdb
			man/hwdb.7
			# Fixme! Convert from systemd-hwdb.8! New patchset!
			#man/udev-hwdb.8
		)
	fi
	eninja "${targets[@]}"
}

src_test() {
	# The testsuite is *very* finicky. Don't try running it in
	# containers or anything but a full VM or on bare metal.
	# udev calls 'mknod' a number of times, and this interacts
	# badly with kernel namespaces.

	if [[ ! -w /dev ]]; then
		ewarn "udev tests needs full access to /dev"
		ewarn "Skipping tests"
	else
		meson-multilib_src_test
	fi
}

multilib_src_test() {
	# two binaries required by udev-test.pl
	eninja systemd-detect-virt test-udev
	local -x PATH="${PWD}:${PATH}"

	# prepare ${BUILD_DIR}/test/sys, required by udev-test.pl
	"${EPYTHON}" "${S}"/test/sys-script.py test || die

	# the perl script contains all the udev tests
	"${S}"/test/udev-test.pl || die
}

multilib_src_install() {
	local libudev=$(readlink libudev.so.1)

	dolib.so {${libudev},libudev.so.1,libudev.so}
	gen_usr_ldscript -a udev

	insinto "/usr/$(get_libdir)/pkgconfig"
	doins src/libudev/libudev.pc

	if multilib_is_native_abi ; then
		exeinto /sbin
		doexe udevadm udevd udev-hwdb
		dosym ../sbin/udevadm /bin/udevadm

		exeinto /lib/udev
		doexe {ata_id,cdrom_id,fido_id,iocost,mtd_probe,scsi_id,v4l_id}

		if have_dmi; then
			doexe dmi_memory_id
		fi

		# Install generated rules (${BUILD_DIR}/rules.d/*.rules)
		rm -f rules.d/99-systemd.rules
		insinto /lib/udev/rules.d
		doins rules.d/*.rules
		insinto /lib/udev/hwdb.d
		doins hwdb.d/*.hwdb

		insinto /usr/share/pkgconfig
		doins src/udev/udev.pc

		#mv man/systemd-udevd.service.8 man/systemd-udevd.8 || die
		rm man/systemd-udevd-{control,kernel}.socket.8 || die
		doman man/*.[0-9]
	fi
}

multilib_src_install_all() {
	doheader src/libudev/libudev.h

	insinto /etc/udev
	doins src/udev/udev.conf
	keepdir /etc/udev/{hwdb.d,rules.d}

	insinto /lib/udev/network
	doins network/99-default.link

	# Install static rules (${S}/rules.d/*.rules)
	insinto /lib/udev/rules.d
	doins rules.d/*.rules
	doins "${FILESDIR}"/40-gentoo.rules
	# this file is provided by sys-auth/elogind
	rm ${ED}/lib/udev/rules.d/70-power-switch.rules || die

	insinto /lib/udev/hwdb.d
	doins hwdb.d/*.hwdb

	dobashcomp shell-completion/bash/udevadm

	insinto /usr/share/zsh/site-functions
	doins shell-completion/zsh/_udevadm

	einstalldocs
}

pkg_postinst() {
	local netrules="80-net-setup-link.rules"
	local net_rules="${ROOT}"/etc/udev/rules.d/${netrules}
	copy_net_rules() {
		[[ -f ${net_rules} ]] || cp "${ROOT}"/usr/share/doc/${PF}/gentoo/${netrules} "${net_rules}"
	}

	if [[ ${REPLACING_VERSIONS} ]] && [[ ${REPLACING_VERSIONS} < 209 ]] ; then
		ewarn "Because this is a upgrade we disable the new predictable network interface"
		ewarn "name scheme by default."
		copy_net_rules
	fi

	if [[ -n "${net_rules}" ]] ; then
		ewarn
		ewarn "udev-197 and newer introduces a new method of naming network"
		ewarn "interfaces. The new names are a very significant change, so"
		ewarn "they are disabled by default on live systems."
		ewarn "Please see the contents of ${net_rules} for more"
		ewarn "information on this feature."
		ewarn
	fi

	local fstab="${ROOT}"/etc/fstab dev path fstype rest
	while read -r dev path fstype rest ; do
		if [[ ${path} == /dev && ${fstype} != devtmpfs ]] ; then
			ewarn "You need to edit your /dev line in ${fstab} to have devtmpfs"
			ewarn "filesystem. Otherwise udev won't be able to boot."
			ewarn "See, https://bugs.gentoo.org/453186"
		fi
	done < "${fstab}"

	if [[ -d ${ROOT}/usr/lib/udev ]] ; then
		ewarn
		ewarn "Please re-emerge all packages on your system which install"
		ewarn "rules and helpers in /usr/lib/udev. They should now be in"
		ewarn "/lib/udev."
		ewarn
		ewarn "One way to do this is to run the following command:"
		ewarn "emerge -av1 \$(qfile -CSq /usr/lib/udev | xargs)"
		ewarn "Note that qfile can be found in app-portage/portage-utils"
	fi

	ewarn
	ewarn "You need to restart udev as soon as possible to make the upgrade go"
	ewarn "into effect."
	ewarn "The method you use to do this depends on your init system."
	if has_version 'sys-apps/openrc' ; then
		ewarn "For sys-apps/openrc users it is:"
		ewarn "# /etc/init.d/udev --nodeps restart"
	fi

	elog
	elog "For more information on udev on Gentoo, upgrading, writing udev rules, and"
	elog "fixing known issues visit:"
	elog "https://wiki.gentoo.org/wiki/Udev"
	elog "https://wiki.gentoo.org/wiki/Udev/upgrade"

	# Update hwdb database in case the format is changed by udev version.
	if has_version 'sys-apps/hwids[udev]' || has_version 'sys-apps/hwdata' ; then
		ebegin "Updating hwdb"
		udev-hwdb --root="${ROOT}" update
		eend $?
	fi
	udev_reload
}

pkg_postrm() {
	udev_reload
}
