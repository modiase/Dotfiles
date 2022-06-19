#!/usr/bin/env -S bash -eux
# Installs homebrew for Linux.
# Compatible distributions are those supported by the homebrew installer –
# i.e., Debian, Ubuntu, Fedora, CentOS or Red Hat

if [[ $UID -ne 0 ]]; then
	echo "Must be run as root."
	exit 0
fi

type brew && (echo "Brew already installed"; exit 0)

PKG_MANAGER=""

type apt && PKG_MANAGER="apt"
type yum && PKG_MANAGER="yum"

if [[ -z "${PKG_MANAGER}" ]]; then
	echo "Unable to find a supported package manager"
	exit 1
fi

if [[ "${PKG_MANAGER}" == "apt" ]]; then
	(apt-get update && apt-get install build-essential procps curl file git \
		|| (echo "Failed to install build dependencies"; exit 1)
elif [[ "${PKG_MANAGER}" == "yum" ]]; then
	(yum update && yum groupinstall 'Development Tools' && yum install procps-ng curl file git && yum install libxcrypt-compat) \
		|| (echo "Failed to install build dependencies"; exit 1)
else
	echo "Invalid package manager"
	exit 1
fi

curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash

type brew \
	&& (echo "Brew installed"; exit 0) \
	|| (echo "Failed to install brew"; exit 1)


echo "Something unexpected happened"
exit 1
