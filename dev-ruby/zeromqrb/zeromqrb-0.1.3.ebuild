# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Tiny wrapper around ffi-rzmq that raises errors"
HOMEPAGE="https://github.com/avalanche123/zeromqrb"
SRC_URI="https://github.com/avalanche123/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

IUSE=""
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

ruby_add_rdepend ">=dev-ruby/ffi-rzmq-2"

all_ruby_prepare() {
	sed -i -e '/git ls-files/d' ${RUBY_FAKEGEM_GEMSPEC} || \
		die "Couldn't modify ${RUBY_FAKEGEM_GEMSPEC} :("
}
