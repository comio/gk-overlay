# Copyright 2011-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit pax-utils unpacker shell-completion edo

DESCRIPTION="GitKraken on the command line."
HOMEPAGE="https://github.com/gitkraken/gk-cli"
SRC_URI="
	amd64? ( https://github.com/gitkraken/gk-cli/releases/download/v${PV}/gk_${PV}_linux_amd64.zip )
	arm64? ( https://github.com/gitkraken/gk-cli/releases/download/v${PV}/gk_${PV}_linux_arm64.zip )
"
S=${WORKDIR}

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"
IUSE="+completion"

RESTRICT="bindist mirror strip"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

pkg_nofetch() {
	eerror "Please wait 24 hours and sync your tree before reporting a bug for fetch failures."
}

src_compile() {
	if use completion; then
		ebegin "Generating shell completions"
		${S}/gk completion bash > gk.bash-completion
		${S}/gk completion fish > gk.fish-completion
		${S}/gk completion zsh > gk.zsh-completion
		eend $?
	fi
}

src_install() {
	exeinto /opt/gk-cli/bin
	doexe ${S}/gk
	dosym /opt/gk-cli/bin/gk /usr/bin/gk
	dodoc ${S}/README.md

	if use completion; then
		ebegin "Installing shell completions"
		newbashcomp "${S}/gk.bash-completion" "gk"
		newzshcomp "${S}/gk.zsh-completion" "_gk"
		dofishcomp "${S}/gk.fish-completion" "gk"
		eend $?
	fi
}
