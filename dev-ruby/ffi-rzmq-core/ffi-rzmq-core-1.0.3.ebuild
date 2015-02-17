# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_TEST="spec"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="FFI wrapper around the zeromq libzmq C API"
HOMEPAGE="https://github.com/chuckremes/ffi-rzmq-core"
SRC_URI="http://github.com/chuckremes/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

IUSE=""
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND+=" >=net-libs/zeromq-3.2"
ruby_add_rdepend ">=dev-ruby/ffi-1.9"

DEPEND+=" >=net-libs/zeromq-3.2"
ruby_add_bdepend ">=dev-ruby/ffi-1.9"

all_ruby_prepare() {
	sed -i -e '/git ls-files/d' ${RUBY_FAKEGEM_GEMSPEC} || \
		die "Couldn't modify ${RUBY_FAKEGEM_GEMSPEC} :("
}
