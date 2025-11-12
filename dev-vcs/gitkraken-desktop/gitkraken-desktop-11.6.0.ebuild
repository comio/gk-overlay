# Copyright 2011-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop pax-utils unpacker edo xdg

DESCRIPTION="GitKraken Legendary Git Tools."
HOMEPAGE="https://github.com/gitkraken/gk-cli"
SRC_URI="
	https://api.gitkraken.dev/releases/production/linux/x64/active/gitkraken-amd64.deb -> ${P}-amd64.deb"
S=${WORKDIR}

LICENSE="Gitkraken-EULA"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE=""

RESTRICT="bindist mirror strip"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

QA_PREBUILT="*"

pkg_nofetch() {
	eerror "Please wait 24 hours and sync your tree before reporting a bug for fetch failures."
}

src_prepare() {
	GITKRAKEN_APPLICATIONS_DIR=usr/share/applications
	for i in ${GITKRAKEN_APPLICATIONS_DIR}/*.desktop; do
		sed -i -e "s|Exec=/usr/share/gitkraken/gitkraken|Exec=/usr/bin/gitkraken|g" "${i}" || die
	done
	default
}

src_install() {
	GITKRAKEN_PKG_HOME=usr/share/gitkraken

	einfo "Installing GitKraken Desktop"
	insinto /usr/share/pixmaps
	doins ${GITKRAKEN_PKG_HOME}/*.png

	# install in /opt/gitkraken
	einfo "Installing GitKraken Desktop files in /opt/gitkraken"
	GITKRAKEN_HOME=/opt/gitkraken
	# Copy main files over to image and preserve permissions so it is portable
	mkdir -p "${ED}/opt" || die
	cp -rp ${GITKRAKEN_PKG_HOME} "${ED}/opt" || die
	fperms +x ${GITKRAKEN_HOME}/gitkraken
	fperms +x ${GITKRAKEN_HOME}/resources/bin/gitkraken.sh

	# create symlink in /usr/bin
	einfo "Creating symlink /usr/bin/gitkraken"
	dodir /usr/bin
	dosym /opt/gitkraken/resources/bin/gitkraken.sh /usr/bin/gitkraken

	einfo "Installing desktop files and icons"
	local size
	for size in 16 22 24 32 48 64 128 256 512; do
		newicon -s ${size} "${GITKRAKEN_PKG_HOME}/gitkraken.png" "gitkraken.png"
	done

	GITKRAKEN_APPLICATIONS_DIR=usr/share/applications
	domenu "${GITKRAKEN_APPLICATIONS_DIR}/gitkraken-url-handler.desktop"
	domenu "${GITKRAKEN_APPLICATIONS_DIR}/gitkraken.desktop"
	domenu "${GITKRAKEN_APPLICATIONS_DIR}/gk-cli-url-handler.desktop"
}
