# Copyright (c) 2018 The Fyde OS Authors. All rights reserved.
# Distributed under the terms of the BSD

EAPI="7"

#EGIT_REPO_URI="https://github.com/balena-os/brcm_patchram_plus.git"
#EGIT_COMMIT="6ca3a2dcf28f5a3c3cc9c127daa153004753ad32"

inherit user

LICENSE="BSD-Fyde"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}"

S=${WORKDIR}
#S=$FILESDIR

src_install() {
  exeinto '/usr/sbin'
# binary copy from official opios 5b
  doexe ${FILESDIR}/brcm_patchram_plus
}
