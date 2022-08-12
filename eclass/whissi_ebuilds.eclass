# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
#
# @ECLASS: whissi_ebuilds.eclass
# @MAINTAINER:
# Thomas Deutschmann <whissi@whissi.de>
# @AUTHOR:
# Author: Thomas Deutschmann <whissi@whissi.de>
# Based on the work of: Polynomial-C
# @BLURB: An eclass for all _pre ebuilds.

# @ECLASS_VARIABLE: MY_PV
# @DESCRIPTION:
# Set to PV without _* suffix.
MY_PV="${PV%_*}"

# @ECLASS_VARIABLE: MY_P
# @DESCRIPTION:
# Set to PN-MYPV, basically P without _* suffix.
MY_P="${PN}-${MY_PV}"

S="${WORKDIR}/${MY_P}"

RESTRICT="mirror"
