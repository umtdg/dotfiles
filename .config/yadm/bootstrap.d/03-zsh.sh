#!/usr/bin/env bash

set -e

distro="$(grep '^ID=.*$' /etc/os-release | cut -d'=' -f2 | xargs)"

function ubuntu_install() {
    echo -e "Installing Oh My Zsh\n"
    git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh

    echo -e "\nInstalling powerlevel10k\n"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

    echo -e "\nInstalling zsh-syntax-highlighting\n"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

    echo -e "\nInstalling zsh-autosuggestions\n"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

    echo -e "\nInstalling zsh-fzf-plugin\n"
    git clone https://github.com/unixorn/fzf-zsh-plugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin
}

function arch_install() {
    yay -S --needed --noconfirm --noeditmenu --nodiffmenu --nocleanmenu --nocleanafter \
        zsh oh-my-zsh-git zsh-theme-powerlevel10k \
        zsh-syntax-highlighting zsh-autosuggestions \
        zsh-fzf-plugin-git

    zsh_custom_dir=${ZSH_CUSTOM:-/usr/share/oh-my-zsh/custom}

    sudo ln -sf /usr/share/zsh-theme-powerlevel10k ${zsh_custom_dir}/themes/powerlevel10k
    sudo ln -sf /usr/share/zsh/plugins/zsh-autosuggestions ${zsh_custom_dir}/plugins/zsh-autosuggestions
    sudo ln -sf /usr/share/zsh/plugins/zsh-syntax-highlighting ${zsh_custom_dir}/plugins/zsh-syntax-highlighting
    sudo ln -sf /usr/share/zsh/plugins/zsh-fzf-plugin ${zsh_custom_dir}/plugins/zsh-fzf-plugin
}


echo -e "\n\nBootstrap ZSH\n"
${distro}_install

