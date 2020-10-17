#!/usr/bin/bash

set -oeu pipefail

APP=${1}

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak-builder --user \
	       --install-deps-from=flathub \
	       --force-clean \
	       _build \
	       --repo=_repo \
	       "${APP}.yml"

flatpak build-bundle \
	--arch=x86_64 \
	_repo \
	"${APP}.flatpak" \
        "${APP}" \
        stable

