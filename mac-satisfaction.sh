#!/usr/bin/env zsh

successfully() {
  $* || (fancy_echo "failed" 1>&2 && exit 1)
}

fancy_echo() {
  echo "\n$1"
}

fancy_echo "Updating mysql config ..."
  successfully vim /usr/local/Cellar/mysql

fancy_echo "Creating satisfaction development workspace ..."
  mkdir -p ~/Code/satisfaction

fancy_echo "Sourcing RVM so it's available as a function ..."
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

fancy_echo "Setting up consumer project ..."
  cd ~/Code/satisfaction
  successfully git clone git@github.com:satisfaction/consumer.git
  cd ~/Code/satisfaction/consumer
  successfully git submodule update --init --recursive
  successfully rvm install ruby-2.1.5
  successfully rvm --create ruby-2.1.5@consumer
  successfully bundle install

fancy_echo "Setting up oneup project ..."
  cd ~/Code/satisfaction
  successfully git clone git@github.com:satisfaction/one-up.git
  cd ~/Code/satisfaction/one-up
  successfully rvm install ruby-2.1.5
  successfully rvm --create ruby-2.1.5@one-up
  successfully bundle install

fancy_echo "Setting up satisfaction project ..."
  cd ~/Code/satisfaction
  successfully git clone git@github.com:satisfaction/satisfaction.git
  cd ~/Code/satisfaction/satisfaction
  successfully git submodule update --init --recursive
  successfully rvm install ree-1.8.7 --verify-downloads 1
  successfully rvm --create ree-1.8.7@satisfaction
  successfully bundle install
  successfully cp config/database.yml.dev config/database.yml
  successfully bundle exec rake sfn:development:config

fancy_echo "Setting up services project ..."
  cd ~/Code/satisfaction
  successfully git clone git@github.com:satisfaction/services.git
  cd ~/Code/satisfaction/services
  successfully git submodule update --init --recursive
  successfully rvm install ruby-2.1.5
  successfully rvm --create ruby-2.1.5@services
  successfully bundle install

fancy_echo "Setting up bizcon project ..."
  cd ~/Code/satisfaction
  successfully git clone git@github.com:satisfaction/bizcon.git
  cd ~/Code/satisfaction/bizcon
  cp config/environment{_sample,}.coffee && vim $_
  successfully git submodule update --init --recursive
  successfully npm install -g bower grunt-cli handlebars coffee-script mocha-phantomjs node-dev node-inspector
  successfully npm install
  successfully bower install

fancy_echo "Setting up ironfan-homebase ..."
  cd ~/Code/satisfaction
  successfully git clone git@github.com:satisfaction/ironfan-homebase.git
  cd ~/Code/satisfaction/ironfan-homebase
  successfully rvm install ruby-1.9.3-p194
  successfully rvm --create ruby-1.9.3-p194@ironfan-homebase
  successfully bundle install
  successfully ln -s ~/Code/ironfan-homebase/knife ~/.chef
  successfully vim ~/.chef/credentials/andyhite.pem
  successfully vim ~/.chef/credentials/knife-user-andyhite.rb

fancy_echo "Setting up tools ..."
  cd ~/Code/satisfaction
  successfully git clone git@github.com:satisfaction/tools
  cd ~/Code/satisfaction/tools
  successfully git submodule update --init --recursive
  successfully rvm install ruby-1.9.3-p448
  successfully rvm --create ruby-1.9.3-p448@tools
  successfully bundle install
  successfully ln -s ~/Code/satisfaction/tools /usr/local/bin

fancy_echo "Downloading pwsafe data ..."
  cd ~/Code/satisfaction
  successfully git clone git@github.com:satisfaction/pwsafe.git

fancy_echo "Installing nerds certificate ..."
  successfully open ~/Code/satisfaction/satisfaction/config/ssl/ca.crt

fancy_echo "Seeding the satisfaction application ..."
  cd ~/Code/satisfaction/satisfaction
  successfully bundle exec rake db:snapshots:geck:run_and_seed
