#!/usr/bin/env zsh

successfully() {
  $* || (echo "failed" 1>&2 && exit 1)
}

echo "Checking for SSH key, generating one if it doesn't exist ..."
  [[ -f ~/.ssh/id_rsa.pub ]] || ssh-keygen -t rsa

echo "Copying public key to clipboard. Paste it into your Github account ..."
  [[ -f ~/.ssh/id_rsa.pub ]] && cat ~/.ssh/id_rsa.pub | pbcopy
  successfully open https://github.com/account/ssh

echo "Fixing permissions ..."
  successfully sudo mkdir -p /usr/local
  successfully sudo chown -R `whoami` /usr/local

echo "Installing Homebrew, a good OS X package manager ..."
  successfully ruby <(curl -fsS https://raw.github.com/mxcl/homebrew/go)
  successfully brew update

echo "Installing GNU Compiler Collection and dependencies ..."
  successfully brew tap homebrew/dupes
  successfully brew install autoconf automake apple-gcc42

echo "Installing system libraries recommended for Ruby ..."
  successfully brew install gdbm libffi libksba libyaml

echo "Installing git, the amazing distributed version control system ..."
  successfully brew install git
  successfully brew install git-extras

echo "Installing MySQL, an okay open source relational database ..."
  successfully brew install mysql
  successfully unset TMPDIR
  successfully mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp

echo "Installing Postgres, a good open source relational database ..."
  successfully brew install postgres --no-python
  successfully initdb /usr/local/var/postgres -E utf8

echo "Installing Redis, a good key-value database ..."
  successfully brew install redis

echo "Installing Memcached, a distributed memory object caching system ..."
  successfully brew install memcached

echo "Installing ack, for searching the contents of files ..."
  successfully brew install ack

echo "Installing grep, because the pre-installed version has some shortcomings ..."
  successfully brew install homebrew/dupes/grep

echo "Installing ctags, for indexing files for vim tab completion of methods, classes, variables ..."
  successfully brew install ctags

echo "Installing tmux, for saving project state and switching between projects ..."
  successfully brew install tmux

echo "Installing reattach-to-user-namespace, for copy-paste and RubyMotion compatibility with tmux ..."
  successfully brew install reattach-to-user-namespace

echo "Installing ImageMagick, for cropping and re-sizing images ..."
  successfully brew install imagemagick

echo "Installing QT, used by Capybara Webkit for headless Javascript integration testing ..."
  successfully brew install qt

echo "Installing watch, used to execute a program periodically and show the output ..."
  successfully brew install watch

echo "Installing vim, because it's the best text editor to ever grace the face of the planet ..."
  successfully brew install vim

echo "Installing nginx, a good web server ..."
  successfully brew install nginx

echo "Installing node, a runtime for server-side JavaScript ..."
  successfully brew install node

echo "Installing openssl, because Ruby depends on it ..."
  successfully brew install openssl

echo "Installing RVM, for managing Rubies and gemsets ..."
  successfully curl -L https://get.rvm.io | bash -s stable --ruby

echo "Installing Ruby 1.9.3 ..."
  successfully CC=gcc-4.2 rvm install 1.9.3 --with-openssl-dir=/usr/local --without-tk --without-tcl

echo "Setting Ruby 1.9.3 as global default Ruby ..."
  successfully rvm --default use 1.9.3

echo "Update to latest Rubygems version ..."
  successfully gem update --system

echo "Installing critical Ruby gems for Rails development ..."
  successfully gem install bundler foreman pg rails mysql unicorn --no-rdoc --no-ri

echo "Installing standalone Heroku CLI client."
  successfully brew install heroku-toolbelt

echo "Installing the heroku-config plugin for pulling config variables locally to be used as ENV variables ..."
  successfully heroku plugins:install git://github.com/ddollar/heroku-config.git

echo "Installing Janus, a collection of vim plugins and keybindings ..."
  successfully curl -Lo- https://bit.ly/janus-bootstrap | bash

#echo "Installing dotfiles ..."
  #successfully git clone git://github.com/andyhite/dotfiles.git ~/.dotfiles
  #successfully cd ~/.dotfiles && git submodule update --init && ./install.sh

echo "Your shell will now restart in order for changes to apply."
  exec $SHELL -l
