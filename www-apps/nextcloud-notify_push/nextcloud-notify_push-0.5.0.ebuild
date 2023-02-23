# Copyright 2017-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

CRATES="
addr2line-0.17.0
adler-1.0.2
ahash-0.7.6
ahash-0.8.0
aho-corasick-0.7.19
android_system_properties-0.1.5
ansi_term-0.12.1
async-stream-0.3.3
async-stream-impl-0.3.3
async-trait-0.1.57
atoi-0.3.3
atoi-1.0.0
atty-0.2.14
autocfg-1.1.0
backtrace-0.3.66
base64-0.13.0
base64ct-1.5.2
beef-0.5.2
bitflags-1.3.2
block-buffer-0.10.3
buf_redux-0.8.4
bumpalo-3.11.0
byteorder-1.4.3
bytes-1.2.1
cc-1.0.73
cfg-if-1.0.0
chrono-0.4.22
chunked_transfer-1.4.0
clap-2.34.0
combine-4.6.6
const-oid-0.7.1
core-foundation-sys-0.8.3
cpufeatures-0.2.5
crc-3.0.0
crc-catalog-2.1.0
crc16-0.4.0
crc32fast-1.3.2
crossbeam-queue-0.3.6
crossbeam-utils-0.8.12
crypto-bigint-0.3.2
crypto-common-0.1.6
dashmap-5.4.0
der-0.5.1
derivative-2.2.0
digest-0.10.5
dirs-4.0.0
dirs-sys-0.3.7
dotenv-0.15.0
dotenvy-0.15.5
either-1.8.0
encoding_rs-0.8.31
event-listener-2.5.3
fastrand-1.8.0
flate2-1.0.24
flexi_logger-0.23.3
flume-0.10.14
fnv-1.0.7
form_urlencoded-1.1.0
futures-0.3.24
futures-channel-0.3.24
futures-core-0.3.24
futures-executor-0.3.24
futures-intrusive-0.4.0
futures-io-0.3.24
futures-macro-0.3.24
futures-sink-0.3.24
futures-task-0.3.24
futures-util-0.3.24
generic-array-0.14.6
getrandom-0.2.7
gimli-0.26.2
glob-0.3.0
h2-0.3.14
hashbrown-0.12.3
hashlink-0.8.1
headers-0.3.8
headers-core-0.2.0
heck-0.3.3
heck-0.4.0
hermit-abi-0.1.19
hex-0.4.3
hkdf-0.12.3
hmac-0.12.1
http-0.2.8
http-auth-basic-0.3.3
http-body-0.4.5
httparse-1.8.0
httpdate-1.0.2
hyper-0.14.20
hyper-rustls-0.23.0
iana-time-zone-0.1.50
idna-0.3.0
indexmap-1.9.1
instant-0.1.12
ipnet-2.5.0
is_ci-1.1.1
itertools-0.10.5
itoa-1.0.3
js-sys-0.3.60
lazy_static-1.4.0
libc-0.2.134
libm-0.2.5
libsqlite3-sys-0.24.2
lock_api-0.4.9
log-0.4.17
logos-0.12.1
logos-derive-0.12.1
matchers-0.0.1
md-5-0.10.5
memchr-2.5.0
miette-3.3.0
miette-5.3.0
miette-derive-3.3.0
miette-derive-5.3.0
mime-0.3.16
mime_guess-2.0.4
mini-redis-0.4.1
minimal-lexical-0.2.1
miniz_oxide-0.5.4
mio-0.8.4
multipart-0.18.0
nextcloud-config-parser-0.6.0
nextcloud_appinfo-0.6.0
nom-7.1.1
num-bigint-0.4.3
num-bigint-dig-0.8.1
num-integer-0.1.45
num-iter-0.1.43
num-traits-0.2.15
num_cpus-1.13.1
num_threads-0.1.6
object-0.29.0
once_cell-1.15.0
owo-colors-3.5.0
parking_lot-0.11.2
parking_lot-0.12.1
parking_lot_core-0.8.5
parking_lot_core-0.9.3
parse-display-0.6.0
parse-display-derive-0.6.0
paste-1.0.9
pem-rfc7468-0.3.1
percent-encoding-2.2.0
peresil-0.3.0
php-literal-parser-0.5.0
pin-project-1.0.12
pin-project-internal-1.0.12
pin-project-lite-0.2.9
pin-utils-0.1.0
pkcs1-0.3.3
pkcs8-0.8.0
pkg-config-0.3.25
ppv-lite86-0.2.16
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
proc-macro2-1.0.46
quick-error-1.2.3
quote-1.0.21
rand-0.8.5
rand_chacha-0.3.1
rand_core-0.6.4
redis-0.21.6
redox_syscall-0.2.16
redox_users-0.4.3
regex-1.6.0
regex-automata-0.1.10
regex-syntax-0.6.27
remove_dir_all-0.5.3
reqwest-0.11.12
rfc7239-0.1.0
ring-0.16.20
rsa-0.6.1
rustc-demangle-0.1.21
rustls-0.20.6
rustls-pemfile-0.2.1
rustls-pemfile-1.0.1
rustversion-1.0.9
ryu-1.0.11
safemem-0.3.3
scoped-tls-1.0.0
scopeguard-1.1.0
sct-0.7.0
semver-0.10.0
semver-parser-0.7.0
serde-1.0.145
serde_derive-1.0.145
serde_json-1.0.85
serde_urlencoded-0.7.1
sha-1-0.10.0
sha1-0.10.5
sha1-0.6.1
sha1_smol-1.0.0
sha2-0.10.6
sharded-slab-0.1.4
signal-hook-registry-1.4.0
slab-0.4.7
smallvec-1.10.0
smawk-0.3.1
socket2-0.4.7
spin-0.5.2
spin-0.9.4
spki-0.5.4
sqlformat-0.2.0
sqlx-0.6.2
sqlx-core-0.6.2
sqlx-macros-0.6.2
sqlx-rt-0.6.2
stringprep-0.1.2
strsim-0.8.0
structmeta-0.1.5
structmeta-derive-0.1.5
structopt-0.3.26
structopt-derive-0.4.18
subtle-2.4.1
supports-color-1.3.0
supports-hyperlinks-1.2.0
supports-unicode-1.0.2
sxd-document-0.3.2
sxd-xpath-0.4.2
syn-1.0.101
tempfile-3.3.0
terminal_size-0.1.17
textwrap-0.11.0
textwrap-0.14.2
textwrap-0.15.1
thiserror-1.0.37
thiserror-impl-1.0.37
thread_local-1.1.4
time-0.3.15
time-macros-0.2.4
tinyvec-1.6.0
tinyvec_macros-0.1.0
tokio-1.21.2
tokio-macros-1.8.0
tokio-rustls-0.23.4
tokio-stream-0.1.10
tokio-tungstenite-0.17.2
tokio-util-0.7.4
tower-service-0.3.2
tracing-0.1.36
tracing-attributes-0.1.22
tracing-core-0.1.29
tracing-futures-0.2.5
tracing-log-0.1.3
tracing-serde-0.1.3
tracing-subscriber-0.2.25
try-lock-0.2.3
tungstenite-0.17.3
twoway-0.1.8
typed-arena-1.7.0
typenum-1.15.0
uncased-0.9.7
unicase-2.6.0
unicode-bidi-0.3.8
unicode-ident-1.0.4
unicode-linebreak-0.1.4
unicode-normalization-0.1.22
unicode-segmentation-1.10.0
unicode-width-0.1.10
unicode_categories-0.1.1
untrusted-0.7.1
ureq-2.5.0
url-2.3.1
utf-8-0.7.6
valuable-0.1.0
vcpkg-0.2.15
vec_map-0.8.2
version_check-0.9.4
want-0.3.0
warp-0.3.3
warp-real-ip-0.2.0
wasi-0.11.0+wasi-snapshot-preview1
wasm-bindgen-0.2.83
wasm-bindgen-backend-0.2.83
wasm-bindgen-futures-0.4.33
wasm-bindgen-macro-0.2.83
wasm-bindgen-macro-support-0.2.83
wasm-bindgen-shared-0.2.83
web-sys-0.3.60
webpki-0.22.0
webpki-roots-0.22.5
whoami-1.2.3
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
windows-sys-0.36.1
windows_aarch64_msvc-0.36.1
windows_i686_gnu-0.36.1
windows_i686_msvc-0.36.1
windows_x86_64_gnu-0.36.1
windows_x86_64_msvc-0.36.1
winreg-0.10.1
xpath_reader-0.5.3
zeroize-1.5.7
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