#!/bin/bash

cd ~
echo "Current directory: $(pwd)"

echo "Installing XCode Commandline Tool..."
xcode-select --install
echo "Completed.\n"

# Install Miniconda3
echo "Downloading Miniconda3..."
curl -o miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh >/dev/null 2>&1

echo "Installing Miniconda3..."
bash Miniconda3-latest-MacOSX-x86_64.sh -b -f -p ~/miniconda3
echo "Completed.\n"

# Install Homebrew
echo "Installing Homebrew..."
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
echo "Completed.\n"

# Install apps
echo "Downloading apps via brew..."
brew install zsh zsh-syntax-highlighting tmux htop go kubernetes-cli kubernetes-helm openssl
echo "Completed.\n"

# Install font repo
echo "Installing apps via brew cask..."
brew tap homebrew/cask-fonts
brew cask install iterm2 atom font-meslo-nerd-font font-hack-nerd-font
echo "Completed.\n"

# Install Oh-My-Zsh
echo "Installing Oh-My-Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
echo "Completed.\n"

# Switch shell
echo "Setting zsh as default shell"
chsh -s /bin/zsh
echo "Completed.\n"

# Oh-My-Zsh Themes
echo "Downloading Oh-My-Zsh Themes..."
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" && \
    ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
echo "Completed.\n"

# Install fonts
echo "Installing Powerline Fonts..."
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts
echo "Completed.\n"

# Download Material Dark Color Scheme
echo "Installing Material Design Color Scheme..."
curl -O https://github.com/mbadolato/iTerm2-Color-Schemes/blob/master/schemes/MaterialDark.itermcolors
echo "Completed.\n"

# Soft link to own zshrc
rm -f ~/.zshrc && ln -s ~/dotfiles/.zshrc ~/.zshrc
echo "All Done!\n"