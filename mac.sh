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

fancy_echo "Beginning installation of applications ..."

fancy_echo "Installing Homebrew ..."
  successfully ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  successfully brew update
  successfully brew tap homebrew/dupes

fancy_echo "Installing Homebrew Cask ..."
  successfully brew tap phinze/homebrew-cask
  successfully brew install brew-cask

fancy_echo "Installing GNU Compiler Collection and dependencies ..."
  successfully brew install autoconf automake apple-gcc42
  export CC=/usr/local/bin/gcc-4.2
  export CXX=/usr/local/bin/c++-4.2

fancy_echo "Installing applications ..."
  successfully brew cask install airmail
  successfully brew cask install alfred
  successfully brew cask install divvy
  successfully brew cask install dropbox
  successfully brew cask install fantastical
  successfully brew cask install firefox
  successfully brew cask install flux
  successfully brew cask install google-chrome
  successfully brew cask install google-drive
  successfully brew cask install iterm2
  successfully brew cask install knox
  successfully brew cask install mou
  successfully brew cask install onepassword
  successfully brew cask install slack
  successfully brew cask install spotify
  successfully brew cask install the-unarchiver
  successfully brew cask install virtualbox
  successfully brew cask install vlc
  successfully brew cask install ynab
  successfully brew cask install zoomus

fancy_echo "Making sure homebrew-cask and Alfred play nice ..."
  successfully brew alfred

fancy_echo "Beginning installation of development tools ..."

fancy_echo "Creating LaunchAgents directory ..."
  successfully mkdir -p ~/Library/LaunchAgents

fancy_echo "Installing Ctags ..."
  successfully brew install ctags

fancy_echo "Installing Elastic Search ..."
  successfully brew install elasticsearch
  ln -sfv /usr/local/opt/elasticsearch/*.plist ~/Library/LaunchAgents
  launchctl load ~/Library/LaunchAgents/homebrew.mxcl.elasticsearch.plist

fancy_echo "Installing Git ..."
  successfully brew install git
  successfully brew install git-extras

fancy_echo "Installing GitHub CLI ..."
  successfully brew install hub

fancy_echo "Installing Grep ..."
  successfully brew install homebrew/dupes/grep

fancy_echo "Installing ImageMagick ..."
  successfully brew install imagemagick

fancy_echo "Installing Memcached ..."
  successfully brew install memcached
  ln -sfv /usr/local/opt/memcached/*.plist ~/Library/LaunchAgents
  launchctl load ~/Library/LaunchAgents/homebrew.mxcl.memcached.plist

fancy_echo "Installing MySQL ..."
  successfully brew install mysql
  ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents
  launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
  successfully unset TMPDIR
  successfully mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp

fancy_echo "Installing Nginx ..."
  successfully brew install nginx
  ln -sfv /usr/local/opt/nginx/*.plist ~/Library/LaunchAgents
  launchctl load ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist

fancy_echo "Installing Node.js ..."
  successfully brew install node

fancy_echo "Installing Postgres ..."
  successfully brew install postgres
  successfully initdb /usr/local/var/postgres -E utf8
  ln -sfv /usr/local/opt/postgres/*.plist ~/Library/LaunchAgents
  launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist

fancy_echo "Installing Rabbit MQ ..."
  successfully brew install rabbitmq
  ln -sfv /usr/local/opt/rabbitmq/*.plist ~/Library/LaunchAgents
  launchctl load ~/Library/LaunchAgents/homebrew.mxcl.rabbitmq.plist

fancy_echo "Installing Python ..."
  successfully brew install python

fancy_echo "Installing QT ..."
  successfully brew install qt

fancy_echo "Installing reattach-to-user-namespace ..."
  successfully brew install reattach-to-user-namespace

fancy_echo "Installing Redis ..."
  successfully brew install redis
  ln -sfv /usr/local/opt/redis/*.plist ~/Library/LaunchAgents
  launchctl load ~/Library/LaunchAgents/homebrew.mxcl.redis.plist

fancy_echo "Installing The Silver Searcher ..."
  successfully brew install the_silver_searcher

fancy_echo "Installing Tig ..."
  successfully brew install tig

fancy_echo "Installing Tmux ..."
  successfully brew install tmux

fancy_echo "Installing Vim ..."
  successfully brew install vim --with-python --with-ruby --with-perl

fancy_echo "Installing Watch ..."
  successfully brew install watch

fancy_echo "Installing Wemux ..."
  successfully brew install wemux

fancy_echo "Installing Wget ..."
  successfully brew install wget

fancy_echo "Installing Zsh ..."
  successfully brew install zsh

fancy_echo "Installing node.js ..."
  successfully brew install node

fancy_echo "Installing phantom.js ..."
  successfully brew install phantomjs

fancy_echo "Installing Powerline ..."
  successfully pip install git+git://github.com/Lokaltog/powerline
  successfully pip install git+git://github.com/xcambar/powerline-segment-battery

fancy_echo "Beginning installation of Ruby environment ..."

fancy_echo "Creating development workspace ..."
  successfully mkdir -p ~/Code

fancy_echo "Installing system libraries recommended for Ruby ..."
  successfully brew install gdbm libffi libksba libyaml openssl

fancy_echo "Installing RVM ..."
  successfully curl -L https://get.rvm.io | bash -s stable --ruby
  successfully source ~/.rvm/scripts/rvm

fancy_echo "Hey RVM - SHHHHHH!"
  successfully rvm rvmrc warning ignore all.rvmrcs

fancy_echo "Installing ruby 2.0.0 ..."
  successfully rvm install 2.1 --with-openssl-dir=`brew --prefix openssl` --without-tk --without-tcl

fancy_echo "Setting Ruby 2.0.0 as global default Ruby ..."
  successfully rvm --default use 2.1

fancy_echo "Update to latest Rubygems version ..."
  successfully gem update --system

fancy_echo "Installing critical Ruby gems for Rails development ..."
  successfully gem install bundler rails --no-rdoc --no-ri

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
