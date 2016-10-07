# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

PHP_EXT_NAME="realpath_turbo"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-5 php5-6 php7-0"

inherit php-ext-source-r3

MY_PV="${PV/_/}"

DESCRIPTION="PHP extension to re-enable realpath cache when using open_basedir restriction"
HOMEPAGE="https://github.com/Whissi/${PN}/"
SRC_URI="https://github.com/Whissi/${PN}/releases/download/v${MY_PV}/${P}.tar.bz2"

LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""

DOCS=( ChangeLog CREDITS LICENSE README.md )
