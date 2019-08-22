#!/bin/bash

spinner() {
  local pid=$!
  local delay=0.5
  local spin_sym='-\|/'
  local i=0
  while kill -0 $pid 2>/dev/null
    do
      i=$(( (i+1) %4 ))
      printf "\r${spin_sym:$i:1}"
      sleep $delay
    done
}

cd ~
echo "Current directory: $(pwd)"

xcode-select -v &> /dev/null
if [[ "${?}" -ne 0 ]]; then
  echo "Installing XCode Commandline Tool"
  xcode-select --install 2> /dev/null &
  spinner
fi

# Install Homebrew
command -v brew &> /dev/null
if [[ "${?}" -ne 0 ]]; then
  echo "Installing Homebrew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" 2> /dev/null &
  spinner
fi

# Install apps
echo "Downloading apps via brew"
brew install zsh zsh-syntax-highlighting tmux htop go kubernetes-cli kubernetes-helm openssl reattach-to-user-namespace \
  cassandra awscli azure-cli 2> /dev/null &
spinner

# Install font repo
echo "Installing apps via brew cask"
brew tap homebrew/cask-fonts && \
brew cask install iterm2 atom docker minikube && \
brew cask install font-hack-nerd-font font-hack-nerd-font-mono font-dejavusansmono-nerd-font font-dejavusansmono-nerd-font-mono 2> /dev/null &
spinner

# Install Oh-My-Zsh
if [[ ! -d "~/.oh-my-zsh" ]]; then
  echo "Installing Oh-My-Zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" 2> /dev/null &
  spinner
fi

# Switch shell
echo "Setting zsh as default shell"
chsh -s /bin/zsh
echo "Done"

# Oh-My-Zsh Themes
ZSH_CUSTOM='~/.oh-my-zsh/custom'

if [[ ! -d "~/.oh-my-zsh/custom/themes/spaceship-prompt" ]]; then
  echo "Downloading Oh-My-Zsh Themes"
  git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" && \
      ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme" && \
  git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k 2> /dev/null &
  spinner
fi

# Install fonts
echo "Installing Powerline Fonts"
git clone https://github.com/powerline/fonts.git --depth=1 && \
cd fonts && \
./install.sh && \
cd .. && \
rm -rf fonts 2> /dev/null &
spinner

# Download Material Dark Color Scheme
echo "Installing Material Design Color Scheme"
curl https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/MaterialDark.itermcolors > ./MaterialDark.itermcolors 2> /dev/null &
spinner

# Soft link to own zshrc
if [[ -f ~/.zshrc ]]; then
  mv ~/.zshrc ~/.zshrc.old
fi
ln -s ~/.dotfiles/.zshrc ~

# Install Miniconda3
command -v conda &> /dev/null
if [[ "${?}" -ne 0 ]]; then
  echo "Downloading Miniconda3"
  curl -o miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh 2> /dev/null &
  spinner
  echo "Installing Miniconda3"
  chmod 400 miniconda.sh && bash miniconda.sh -b -f -p ~/miniconda3 2> /dev/null &
  spinner
fi

# First source ~/.zshrc to include just installed miniconda
 ~/.zshrc
command -v pip | grep miniconda3 &> /dev/null
if [[ "${?}" -ne 0 ]]; then
  echo "Installing python packages"
  pip install ipykernel jupyterlab 2> /dev/null &
  spinner
fi

echo "Installing SpaceVim"
curl -sLf https://spacevim.org/install.sh | bash && \
mkdir ~/.SpaceVim.d/ && ln -h ~/.dotfiles/init.toml ~/.SpaceVim.d/ 2> /dev/null &
spinner

echo "Soft linking tmux config"
if [[ -f ~/.tmux.conf ]]; then
  echo "Renamed ~/.tmux.conf as ~/.tmux.conf.old"
  mv ~/.tmux.conf ~/.tmux.conf.old
fi
ln -s ~/.dotfiles/.tmux.conf ~
ln -sf ~/.dotfiles/.tmux.conf.local ~
echo "Done"

echo "All Done!\n"

echo "Todo Lists:\n"
echo "  * iTerm2 -> Preference -> Profiles -> Text -> Font, Select one of the Powerline Font, eg. Hack Nerd Font Mono\n"
echo "  * iTerm2 -> Preference -> Profiles -> Colors -> Color Presets -> Import, Import ~/MaterialDark.itermcolors and set it as color scheme\n"
echo "  * iTerm2 -> Preference -> Profiles -> Text -> Check 'Use a different font for non-ASCII text' -> Select Hack Nerd Font Mono"
echo "  * https://www.oracle.com/technetwork/java/javase/downloads/index.html -> Download JDK 8, required by Cassandra"