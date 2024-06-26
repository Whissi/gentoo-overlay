# Copyright 2017-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

CRATES="
addr2line-0.21.0
adler-1.0.2
ahash-0.8.11
aho-corasick-1.1.3
allocator-api2-0.2.18
android-tzdata-0.1.1
android_system_properties-0.1.5
ansi_term-0.12.1
anstream-0.6.13
anstyle-1.0.6
anstyle-parse-0.2.3
anstyle-query-1.0.2
anstyle-wincon-3.0.2
async-stream-0.3.5
async-stream-impl-0.3.5
async-trait-0.1.80
atoi-0.3.3
atoi-2.0.0
atty-0.2.14
autocfg-1.2.0
backtrace-0.3.71
backtrace-ext-0.2.1
base64-0.13.1
base64-0.21.7
base64-0.22.0
base64ct-1.6.0
beef-0.5.2
bitflags-1.3.2
bitflags-2.5.0
block-buffer-0.10.4
bumpalo-3.16.0
byteorder-1.5.0
bytes-1.6.0
cc-1.0.96
cfg-if-1.0.0
chrono-0.4.38
clap-2.34.0
clap-4.5.4
clap_builder-4.5.2
clap_derive-4.5.4
clap_lex-0.7.0
colorchoice-1.0.0
combine-4.6.7
concurrent-queue-2.5.0
const-oid-0.9.6
core-foundation-0.9.4
core-foundation-sys-0.8.6
cpufeatures-0.2.12
crc-3.2.1
crc-catalog-2.4.0
crc16-0.4.0
crc32fast-1.4.0
crossbeam-queue-0.3.11
crossbeam-utils-0.8.19
crypto-common-0.1.6
dashmap-5.5.3
data-encoding-2.6.0
der-0.7.9
derivative-2.2.0
digest-0.10.7
dirs-5.0.1
dirs-sys-0.4.1
dotenvy-0.15.7
either-1.11.0
encoding_rs-0.8.34
equivalent-1.0.1
errno-0.3.8
event-listener-3.1.0
finl_unicode-1.2.0
flate2-1.0.30
flexi_logger-0.28.0
flume-0.11.0
fnv-1.0.7
form_urlencoded-1.2.1
futures-0.3.30
futures-channel-0.3.30
futures-core-0.3.30
futures-executor-0.3.30
futures-intrusive-0.5.0
futures-io-0.3.30
futures-macro-0.3.30
futures-sink-0.3.30
futures-task-0.3.30
futures-util-0.3.30
generic-array-0.14.7
getrandom-0.2.14
gimli-0.28.1
glob-0.3.1
h2-0.3.26
hashbrown-0.14.5
hashlink-0.8.4
headers-0.3.9
headers-core-0.2.0
heck-0.3.3
heck-0.4.1
heck-0.5.0
hermit-abi-0.1.19
hermit-abi-0.3.9
hex-0.4.3
hkdf-0.12.4
hmac-0.12.1
http-0.2.12
http-1.1.0
http-auth-basic-0.3.3
http-body-0.4.6
httparse-1.8.0
httpdate-1.0.3
hyper-0.14.28
hyper-rustls-0.24.2
iana-time-zone-0.1.60
iana-time-zone-haiku-0.1.2
idna-0.5.0
indexmap-2.2.6
ipnet-2.9.0
is-terminal-0.4.12
is_ci-1.2.0
itertools-0.12.1
itoa-1.0.11
js-sys-0.3.69
lazy_static-1.4.0
libc-0.2.154
libm-0.2.8
libredox-0.1.3
libsqlite3-sys-0.28.0
linux-raw-sys-0.4.13
lock_api-0.4.12
log-0.4.21
logos-0.14.0
logos-codegen-0.14.0
logos-derive-0.14.0
matchers-0.0.1
md-5-0.10.6
memchr-2.7.2
miette-7.2.0
miette-derive-7.2.0
mime-0.3.17
mime_guess-2.0.4
mini-redis-0.4.1
minimal-lexical-0.2.1
miniz_oxide-0.7.2
mio-0.8.11
multer-2.1.0
nextcloud-config-parser-0.10.0
nextcloud_appinfo-0.6.0
nom-7.1.3
nu-ansi-term-0.49.0
num-bigint-0.4.4
num-bigint-dig-0.8.4
num-integer-0.1.46
num-iter-0.1.44
num-traits-0.2.18
num_cpus-1.16.0
object-0.32.2
once_cell-1.19.0
option-ext-0.2.0
owo-colors-4.0.0
parking-2.2.0
parking_lot-0.12.2
parking_lot_core-0.9.10
parse-display-0.9.0
parse-display-derive-0.9.0
paste-1.0.14
pem-rfc7468-0.7.0
percent-encoding-2.3.1
peresil-0.3.0
php-literal-parser-0.6.0
pin-project-1.1.5
pin-project-internal-1.1.5
pin-project-lite-0.2.14
pin-utils-0.1.0
pkcs1-0.7.5
pkcs8-0.10.2
pkg-config-0.3.30
ppv-lite86-0.2.17
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
proc-macro2-1.0.81
quick-error-1.2.3
quote-1.0.36
rand-0.8.5
rand_chacha-0.3.1
rand_core-0.6.4
redis-0.25.3
redox_syscall-0.4.1
redox_syscall-0.5.1
redox_users-0.4.5
regex-1.10.4
regex-automata-0.1.10
regex-automata-0.4.6
regex-syntax-0.6.29
regex-syntax-0.8.3
reqwest-0.11.27
rfc7239-0.1.1
ring-0.17.8
rsa-0.9.6
rustc-demangle-0.1.23
rustix-0.38.34
rustls-0.21.12
rustls-0.22.4
rustls-pemfile-1.0.4
rustls-pemfile-2.1.2
rustls-pki-types-1.5.0
rustls-webpki-0.101.7
rustls-webpki-0.102.3
ryu-1.0.17
scoped-tls-1.0.1
scopeguard-1.2.0
sct-0.7.1
semver-0.10.0
semver-parser-0.7.0
serde-1.0.199
serde_derive-1.0.199
serde_json-1.0.116
serde_urlencoded-0.7.1
sha1-0.10.6
sha2-0.10.8
sharded-slab-0.1.7
signal-hook-registry-1.4.2
signature-2.2.0
slab-0.4.9
smallvec-1.13.2
smawk-0.3.2
socket2-0.5.7
spin-0.5.2
spin-0.9.8
spki-0.7.3
sqlformat-0.2.3
sqlx-core-oldapi-0.6.20
sqlx-macros-oldapi-0.6.20
sqlx-oldapi-0.6.20
sqlx-rt-oldapi-0.6.20
stringprep-0.1.4
strsim-0.8.0
strsim-0.11.1
structmeta-0.3.0
structmeta-derive-0.3.0
structopt-0.3.26
structopt-derive-0.4.18
subtle-2.5.0
supports-color-3.0.0
supports-hyperlinks-3.0.0
supports-unicode-3.0.0
sxd-document-0.3.2
sxd-xpath-0.4.2
syn-1.0.109
syn-2.0.60
sync_wrapper-0.1.2
system-configuration-0.5.1
system-configuration-sys-0.5.0
terminal_size-0.3.0
textwrap-0.11.0
textwrap-0.16.1
thiserror-1.0.59
thiserror-impl-1.0.59
thread_local-1.1.8
tinyvec-1.6.0
tinyvec_macros-0.1.1
tokio-1.37.0
tokio-macros-2.2.0
tokio-rustls-0.24.1
tokio-rustls-0.25.0
tokio-stream-0.1.15
tokio-tungstenite-0.21.0
tokio-util-0.7.10
tower-service-0.3.2
tracing-0.1.40
tracing-attributes-0.1.27
tracing-core-0.1.32
tracing-futures-0.2.5
tracing-log-0.1.4
tracing-serde-0.1.3
tracing-subscriber-0.2.25
try-lock-0.2.5
tungstenite-0.21.0
typed-arena-1.7.0
typenum-1.17.0
uncased-0.9.10
unicase-2.7.0
unicode-bidi-0.3.15
unicode-ident-1.0.12
unicode-linebreak-0.1.5
unicode-normalization-0.1.23
unicode-segmentation-1.11.0
unicode-width-0.1.12
unicode_categories-0.1.1
untrusted-0.9.0
ureq-2.9.7
url-2.5.0
urlencoding-2.1.3
utf-8-0.7.6
utf8parse-0.2.1
valuable-0.1.0
vcpkg-0.2.15
vec_map-0.8.2
version_check-0.9.4
want-0.3.1
warp-0.3.7
warp-real-ip-0.2.0
wasi-0.11.0+wasi-snapshot-preview1
wasite-0.1.0
wasm-bindgen-0.2.92
wasm-bindgen-backend-0.2.92
wasm-bindgen-futures-0.4.42
wasm-bindgen-macro-0.2.92
wasm-bindgen-macro-support-0.2.92
wasm-bindgen-shared-0.2.92
web-sys-0.3.69
webpki-roots-0.25.4
webpki-roots-0.26.1
whoami-1.5.1
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
windows-core-0.52.0
windows-sys-0.48.0
windows-sys-0.52.0
windows-targets-0.48.5
windows-targets-0.52.5
windows_aarch64_gnullvm-0.48.5
windows_aarch64_gnullvm-0.52.5
windows_aarch64_msvc-0.48.5
windows_aarch64_msvc-0.52.5
windows_i686_gnu-0.48.5
windows_i686_gnu-0.52.5
windows_i686_gnullvm-0.52.5
windows_i686_msvc-0.48.5
windows_i686_msvc-0.52.5
windows_x86_64_gnu-0.48.5
windows_x86_64_gnu-0.52.5
windows_x86_64_gnullvm-0.48.5
windows_x86_64_gnullvm-0.52.5
windows_x86_64_msvc-0.48.5
windows_x86_64_msvc-0.52.5
winreg-0.50.0
xpath_reader-0.5.3
zerocopy-0.7.32
zerocopy-derive-0.7.32
zeroize-1.7.0
"

inherit cargo systemd

DESCRIPTION="Push daemon for Nextcloud clients"
HOMEPAGE="https://github.com/nextcloud/notify_push"
SRC_URI="https://github.com/nextcloud/notify_push/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"
LICENSE="MIT Apache-2.0 BSD GPL-3 ISC MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

RDEPEND="acct-group/nobody
	acct-user/nobody"

S="${WORKDIR}/notify_push-${PV}"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_install() {
	cargo_src_install
	einstalldocs

	# default name is too generic
	mv "${ED}/usr/bin/notify_push" "${ED}/usr/bin/${PN}" || die

	newconfd "${FILESDIR}"/${PN}-r1.confd ${PN}
	newinitd "${FILESDIR}"/${PN}-r1.init ${PN}
	systemd_newunit "${FILESDIR}"/${PN}.service ${PN}.service

	# restrict access because conf.d entry could contain
	# database credentials
	fperms 0640 /etc/conf.d/${PN}
}
