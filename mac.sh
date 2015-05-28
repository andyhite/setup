#!/usr/bin/env zsh

successfully() {
  $* || (fancy_echo "failed" 1>&2 && exit 1)
}

fancy_echo() {
  echo "\n$1"
}

if [ -f /etc/zshenv ]; then
  fancy_echo "Fixing OSX zsh environment bug ..."
    successfully sudo mv /etc/{zshenv,zshrc}
fi

fancy_echo "Switching to zshell ..."
  chsh -s /bin/zsh

fancy_echo "Checking for SSH key, generating one if it doesn't exist ..."
  [[ -f ~/.ssh/id_rsa.pub ]] || ssh-keygen -t rsa

fancy_echo "Copying public key to clipboard. Paste it into your Github account ..."
  [[ -f ~/.ssh/id_rsa.pub ]] && cat ~/.ssh/id_rsa.pub | pbcopy
  successfully open https://github.com/account/ssh

fancy_echo "Fixing permissions ..."
  successfully sudo mkdir -p /usr/local
  successfully sudo chown -R `whoami` /usr/local

fancy_echo "Install and set San Francisco as system font ..."
  successfully ruby -e "$(curl -fsSL https://raw.github.com/wellsriley/YosemiteSanFranciscoFont/master/install)"

fancy_echo "Beginning installation of applications ..."

fancy_echo "Installing Homebrew ..."
  successfully ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  successfully brew update
  successfully brew tap homebrew/dupes

fancy_echo "Installing Homebrew Cask ..."
  successfully brew install caskroom/cask/brew-cask
  export HOMEBREW_CASK_OPTS="--appdir=/Applications"

fancy_echo "Installing general applications ..."
  read -p "Please install Airmail via the App Store ..." -n1 -s
  read -p "Please install Pixelmator via the App Store ..." -n1 -s
  read -p "Please install Wunderlist via the App Store ..." -n1 -s
  successfully brew cask install divvy
  successfully brew cask install dropbox
  successfully brew cask install flux
  successfully brew cask install google-chrome
  successfully brew cask install intellij-idea
  successfully brew cask install iterm2
  successfully brew cask install java
  successfully brew cask install 1password
  successfully brew cask install slack
  successfully brew cask install spotify
  successfully brew cask install spotify-notifications
  successfully brew cask install skype
  successfully brew cask install virtualbox
  successfully brew cask install ynab
  successfully brew cask install zoomus

fancy_echo "Beginning installation of development tools ..."
  successfully brew install ctags
  successfully brew install git
  successfully brew install git-extras
  successfully brew install grep
  successfully brew install python
  successfully brew install reattach-to-user-namespace
  successfully brew install the_silver_searcher
  successfully brew install tig
  successfully brew install tmux
  successfully brew install vim --with-python --with-ruby --with-perl
  successfully brew install watch
  successfully brew install wemux
  successfully brew install wget
  successfully brew install zsh
  successfully pip install git+git://github.com/Lokaltog/powerline
  successfully pip install git+git://github.com/xcambar/powerline-segment-battery

fancy_echo "Creating development workspace ..."
  successfully mkdir -p ~/Code

fancy_echo "Installing dotfiles ..."
  successfully git clone git://github.com/andyhite/dotfiles.git ~/.dotfiles
  successfully cd ~/.dotfiles && git submodule update --init && ./install.sh
  echo "Don't forget to create your local rc files!"

fancy_echo "Installing Meslo LG L DZ for Powerline ..."
  successfully open ~/.dotfiles/assets/powerline-fonts/Meslo/Meslo\ LG\ L\ DZ\ Regular\ for\ Powerline.otf

fancy_echo "Configuring iTerm2 preferences ..."
  successfully ln -s ~/.dotfiles/assets/com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist

fancy_echo "Your shell will now restart in order for changes to apply."
  exec $SHELL -l
