# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PHP_EXT_NAME="turbo_realpath"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-6"

inherit php-ext-pecl-r3

DESCRIPTION="PHP extension to re-enable realpath cache when using open_basedir restriction"
HOMEPAGE="https://github.com/Whissi/${PN}/"
SRC_URI="https://github.com/Whissi/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""

DOCS=( ChangeLog CREDITS LICENSE README.md )
