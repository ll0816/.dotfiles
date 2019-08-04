#!/bin/bash

cd ~

xcode-select --install

# Install Miniconda3
curl -o miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
bash Miniconda3-latest-MacOSX-x86_64.sh -b -f -p ~/miniconda3

# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install apps
brew install zsh zsh-syntax-highlighting tmux htop go kubernetes-cli kubernetes-helm openssl

# Install font repo
brew tap homebrew/cask-fonts
brew cask install iterm2 atom font-meslo-nerd-font font-hack-nerd-font


# Install Oh-My-Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Switch shell
chsh -s /bin/zsh

# Oh-My-Zsh Themes
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" && \
    ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

# Install fonts
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts

# Download Material Dark  Color Scheme
curl -O https://github.com/mbadolato/iTerm2-Color-Schemes/blob/master/schemes/MaterialDark.itermcolors

# Soft link to own zshrc
rm -f ~/.zshrc && ln -s ~/dotfiles/.zshrc ~/.zshrc
