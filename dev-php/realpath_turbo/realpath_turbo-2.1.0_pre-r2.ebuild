# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PHP_EXT_NAME="realpath_turbo"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php7-4 php8-0 php8-1 php8-2 php8-3 php8-4"

inherit php-ext-source-r3

MY_PV="${PV/_/}"

DESCRIPTION="PHP extension to re-enable realpath cache when using open_basedir restriction"
HOMEPAGE="https://github.com/Whissi/realpath_turbo/"
SRC_URI="https://mirror.whissi.de/distfiles/${P}.tar.bz2"

LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""

DOCS=( ChangeLog CREDITS LICENSE README.md )
