#!/bin/sh

exec_cmd_with_sudo () {
    if [ "${USER}" = "root" ]; then
        $@
    else
        sudo $@
    fi
}

do_exist_cmd () {
    if type $1 &> /dev/null; then
        return 0
    else
        return 1
    fi
}


if [ -f /.dockerenv ]; then
    if do_exist_cmd "apt"; then
        exec_cmd_with_sudo apt update
        exec_cmd_with_sudo apt install -y fish
    elif do_exist_cmd "yum"; then
        exec_cmd_with_sudo yum update
        exec_cmd_with_sudo yum install -y fish
    fi
fi

if [ $(uname -s) = "Darwin" ]; then
    brew install chezmoi
    chezmoi init --apply https://github.com/ynny-github/dotfiles.git
else
    cd ~/installer
    chmod +x chezmoi_installer.sh
    exec_cmd_with_sudo ./chezmoi_installer.sh -- init --apply https://github.com/ynny-github/dotfiles.git
fi

rm -rf ~/installer
