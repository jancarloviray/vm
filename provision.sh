#!/usr/bin/env bash

lnif() {
  if [ -e "$1" ]; then
    ln -sf "$1" "$2"
  fi
}

msg() {
  printf '%b\n' "$1" >&2
}

success() {
  msg "\33[32m[✔]\33[0m ${1}${2}"
}

update_packages(){
  sudo apt-get update &> /dev/null 2>&1
  success "Updated apt-get"
}

# man, tmux, vim-nox
install_required_packages(){
  sudo apt-get install -y --fix-missing \
  silversearcher-ag \
  vim \
  vim-nox \
  git \
  zsh \
  curl &> /dev/null 2>&1
  success "Installed Required Packages"
}

local_ohmyzsh(){
  sudo chsh -s $(which zsh) vagrant
  rm -rf .oh-my-zsh && \
  cp -R "/vagrant/backup/oh-my-zsh" "$HOME/" && \
  mv oh-my-zsh .oh-my-zsh && \
  sh "/vagrant/tools/install_ohmyzsh.sh"
  cp "/vagrant/config/zsh/.zshrc" "$HOME/.zshrc"
  success "Installed Oh-my-zsh"
}

local_tmux(){
  cp -R "/vagrant/backup/tmux" "$HOME/" && \
  mv tmux .tmux && \
  cp "/vagrant/config/tmux/.tmux.conf" "$HOME/.tmux.conf"
  success "Finished tmux setup"
}

local_spf13(){
  sh "/vagrant/tools/install_spf13.sh"
  success "Installed spf13"
}

update_packages
install_required_packages
local_ohmyzsh
local_spf13
local_tmux

sudo chsh -s $(which zsh) vagrant

success "Minimal Setup Done. Run /vagrant/tools/install_*.sh for extra pachages."