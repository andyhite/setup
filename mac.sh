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
  successfully ruby <(curl -fsS https://raw.github.com/mxcl/homebrew/go)
  successfully brew update
  successfully brew tap homebrew/dupes

fancy_echo "Installing Homebrew Cask ..."
  successfully brew tap phinze/homebrew-cask
  successfully brew install brew-cask

fancy_echo "Installing GNU Compiler Collection and dependencies ..."
  successfully brew install autoconf automake apple-gcc42

fancy_echo "Installing Google Chrome ..."
  successfully brew cask install google-chrome

fancy_echo "Installing Adium ..."
  successfully brew cask install adium

fancy_echo "Installing Alfred ..."
  successfully brew cask install alfred

fancy_echo "Installing Divvy ..."
  successfully brew cask install divvy

fancy_echo "Installing Firefox ..."
  successfully brew cask install firefox

fancy_echo "Installing Growl Notify ..."
  successfully brew cask install growlnotify

fancy_echo "Installing iTerm 2 ..."
  successfully brew cask install iterm2

fancy_echo "Installing The Unarchiver ..."
  successfully brew cask install the-unarchive

fancy_echo "Installing VirtualBox ..."
  successfully brew cask install virtualbox

fancy_echo "Installing VLC ..."
  successfully brew cask install vlc

fancy_echo "Beginning installation of development tools ..."

fancy_echo "Installing Ctags ..."
  successfully brew install ctags

fancy_echo "Installing curl-ca-bundle ..."
  successfully brew install curl-ca-bundle

fancy_echo "Installing Elastic Search ..."
  successfully brew install elasticsearch

fancy_echo "Installing Git ..."
  successfully brew install git
  successfully brew install git-extras

fancy_echo "Installing GitHub CLI ..."
  successfully brew install hub

fancy_echo "Installing Go ..."
  successfully brew install go

fancy_echo "Installing Grep ..."
  successfully brew install homebrew/dupes/grep

fancy_echo "Installing ImageMagick ..."
  successfully brew install imagemagick

fancy_echo "Installing Memcached ..."
  successfully brew install memcached

fancy_echo "Installing Mercurial ..."
  successfully brew install mercurial

fancy_echo "Installing MySQL ..."
  successfully brew install mysql
  successfully unset TMPDIR
  successfully mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp

fancy_echo "Installing Nginx ..."
  successfully brew install nginx

fancy_echo "Installing Node.js ..."
  successfully brew install node

fancy_echo "Installing Play ..."
  successfully brew install play

fancy_echo "Installing Postgres ..."
  successfully brew install postgres
  successfully initdb /usr/local/var/postgres -E utf8

fancy_echo "Installing Python ..."
  successfully brew install python

fancy_echo "Installing QT ..."
  successfully brew install qt

fancy_echo "Installing reattach-to-user-namespace ..."
  successfully brew install reattach-to-user-namespace

fancy_echo "Installing Redis ..."
  successfully brew install redis

fancy_echo "Installing Sbt ..."
  successfully brew install sbt

fancy_echo "Installing Scala ..."
  successfully brew install scala

fancy_echo "Installing The Silver Searcher ..."
  successfully brew install the_silver_searcher

fancy_echo "Installing Sphinx ..."
  successfully brew install sphinx

fancy_echo "Installing Sqlite ..."
  successfully brew install sqlite

fancy_echo "Installing Tig ..."
  successfully brew install tig

fancy_echo "Installing Tmux ..."
  successfully brew install tmux

fancy_echo "Installing Vim ..."
  successfully brew install vim

fancy_echo "Installing Watch ..."
  successfully brew install watch

fancy_echo "Installing Wemux ..."
  successfully brew install wemux

fancy_echo "Installing Wget ..."
  successfully brew install wget

fancy_echo "Beginning installation of Ruby environment ..."

fancy_echo "Installing system libraries recommended for Ruby ..."
  successfully brew install gdbm libffi libksba libyaml openssl

fancy_echo "Installing RVM ..."
  successfully curl -L https://get.rvm.io | bash -s stable --ruby

fancy_echo "Installing Ruby 1.9.3-p392 ..."
  successfully CC=gcc-4.2 rvm install 1.9.3-p392 --with-openssl-dir=/usr/local --without-tk --without-tcl

fancy_echo "Setting Ruby 1.9.3 as global default Ruby ..."
  successfully rvm --default use 1.9.3

fancy_echo "Update to latest Rubygems version ..."
  successfully gem update --system

fancy_echo "Installing critical Ruby gems for Rails development ..."
  successfully gem install bundler foreman pg rails mysql unicorn --no-rdoc --no-ri

fancy_echo "Installing standalone Heroku CLI client."
  successfully brew install heroku-toolbelt

fancy_echo "Installing the heroku-config plugin for pulling config variables locally to be used as ENV variables ..."
  successfully heroku plugins:install git://github.com/ddollar/heroku-config.git

fancy_echo "Installing Janus, a collection of vim plugins and keybindings ..."
  successfully curl -Lo- https://bit.ly/janus-bootstrap | bash

fancy_echo "Installing dotfiles ..."
  successfully git clone git://github.com/andyhite/dotfiles.git ~/.dotfiles
  successfully cd ~/.dotfiles && git submodule update --init && ./install.sh

fancy_echo "Your shell will now restart in order for changes to apply."
  exec $SHELL -l
