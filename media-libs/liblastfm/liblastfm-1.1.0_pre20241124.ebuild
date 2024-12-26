# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=2e8e40d78a331d8e39fe39113bcb7571a7b1d4d6
inherit cmake flag-o-matic

DESCRIPTION="Collection of libraries to integrate Last.fm services"
HOMEPAGE="https://github.com/drfiemost/liblastfm"
SRC_URI="https://github.com/drfiemost/liblastfm/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
SLOT="0/0"
IUSE="fingerprint test"

# 1 of 2 (UrlBuilderTest) is failing, last checked version 1.0.9
RESTRICT="test"

RDEPEND="
	dev-qt/qtbase:6[dbus,network,ssl,xml]
	fingerprint? (
		dev-qt/qtbase:6[sql]
		media-libs/libsamplerate
		sci-libs/fftw:3.0
	)
"

#PATCHES=( "${FILESDIR}/${P}-missing-dep.patch" )

src_prepare() {
	#append-cxxflags -std=c++14 # bug 787128
	cmake_src_prepare
}

src_configure() {
	# demos not working
	local mycmakeargs=(
		-DBUILD_DEMOS=OFF
		-DBUILD_FINGERPRINT=$(usex fingerprint)
		-DBUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}
