# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_TEST="spec"
RUBY_FAKEGEM_EXTRADOC="AUTHORS.txt History.txt README.rdoc"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="FFI bindings for ZeroMQ so the library can be used under JRuby and other FFI-compliant ruby runtimes"
HOMEPAGE="https://github.com/chuckremes/ffi-rzmq"
SRC_URI="https://github.com/chuckremes/${PN}/archive/release-${PV}.tar.gz -> ${P}.tar.gz"

IUSE=""
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

ruby_add_rdepend ">=dev-ruby/ffi-rzmq-core-1.0.1"

ruby_add_bdepend ">=dev-ruby/ffi-rzmq-core-1.0.1"

RUBY_S="ffi-rzmq-release-${PV}"

all_ruby_prepare() {
	sed -i -e '/git ls-files/d' ${RUBY_FAKEGEM_GEMSPEC} || \
		die "Couldn't modify ${RUBY_FAKEGEM_GEMSPEC} :("

	# Upstream screwed up release management, see commit 669ff17f8
	sed -i -e "s/VERSION =.*/VERSION = \"${PV}\"/" "${S}"/lib/ffi-rzmq/version.rb || \
		die "Failed to patch version"
}
