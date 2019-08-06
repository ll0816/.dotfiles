#!/bin/bash

cd ~
echo "Current directory: $(pwd)"

echo "Installing XCode Commandline Tool..."
xcode-select --install
echo "Completed.\n"

# Install Homebrew
command -v brew &>/dev/null
if [[ "${?}" -ne 0 ]]; then
  echo "Installing Homebrew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  echo "Completed.\n"
fi

# Install apps
echo "Downloading apps via brew..."
brew install zsh zsh-syntax-highlighting tmux htop go kubernetes-cli kubernetes-helm openssl reattach-to-user-namespace
echo "Completed.\n"

# Install font repo
echo "Installing apps via brew cask..."
brew tap homebrew/cask-fonts
brew cask install iterm2 atom docker minikube
brew cask install font-hack-nerd-font font-hack-nerd-font-mono font-dejavusansmono-nerd-font font-dejavusansmono-nerd-font-mono
echo "Completed.\n"

# Install Oh-My-Zsh
if [[ ! -d "~/.oh-my-zsh" ]]; then
  echo "Installing Oh-My-Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  echo "Completed.\n"
fi

# Switch shell
echo "Setting zsh as default shell"
chsh -s /bin/zsh
echo "Completed.\n"

# Oh-My-Zsh Themes
if [[ ! -d "~/.oh-my-zsh/custom/themes/spaceship-prompt" ]]; then
  echo "Downloading Oh-My-Zsh Themes..."
  git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" && \
      ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
  git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
  echo "Completed.\n"
fi

# Install fonts
echo "Installing Powerline Fonts..."
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts
echo "Completed.\n"

echo "Downloading Powerline Symbols..."
curl -O https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf

# Download Material Dark Color Scheme
echo "Installing Material Design Color Scheme..."
curl https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/MaterialDark.itermcolors > ./MaterialDark.itermcolors
echo "Completed.\n"

# Soft link to own zshrc
rm -f ~/.zshrc && ln -s ~/.dotfiles/.zshrc

# Install Miniconda3
command -v conda &>/dev/null
if [[ "${?}" -ne 0 ]]; then
  echo "Downloading Miniconda3..."
  curl -o miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
  echo "Installing Miniconda3..."
  chmod 400 miniconda.sh && bash miniconda.sh -b -f -p ~/miniconda3
  echo "Completed.\n"
fi

# Install aws-cli, azure-cli
source ~/.zshrc
which pip | grep miniconda3 &>/dev/null
if [[ "${?}" -ne 0 ]]; then
  echo "Installing aws-cli, azure-cli..."
  pip install awscli azure-cli
  echo "Completed.\n"
fi

echo "Installing SpaceVim..."
curl -sLf https://spacevim.org/install.sh | bash
rm ~/.SpaceVim.d/init.toml && ln -h ~/.dotfiles/init.toml ~/.SpaceVim.d/
echo "Completed.\n"

echo "Soft linking tmux config"
ln -s ~/.dotfiles/.tmux.conf
ln -s ~/.dotfiles/.tmux.conf.local

echo "All Done!\n"

echo "Todo Lists:\n"
echo "  * iTerm2 -> Preference -> Profiles -> Text -> Font, Select one of the Powerline Font, eg. Hack Nerd Font Mono\n"
echo "  * iTerm2 -> Preference -> Profiles -> Colors -> Color Presets -> Import..., Import ~/MaterialDark.itermcolors and set it as color scheme\n"
echo "  * cd ${HOME} -> PowerlineSymbols.otf -> Click to install"
echo "  * iTerm2 -> Preference -> Profiles -> Text -> Check 'Use a different font for non-ASCII text' -> Select Hack Nerd Font Mono"
