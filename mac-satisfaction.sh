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

fancy_echo "Setting up consumer project ..."
  cd ~/Code/satisfaction
  successfully git clone git@github.com:satisfaction/consumer.git
  cd ~/Code/satisfaction/consumer
  successfully git submodule update --init --recursive
  successfully rvm install ruby-1.9.3-p194-falcon --patch falcon
  successfully rvm use ruby-1.9.3-p194-falcon
  successfully rvm gemset create consumer
  successfully rvm gemset use consumer
  successfully bundle install

fancy_echo "Setting up satisfaction project ..."
  cd ~/Code/satisfaction
  successfully git clone git@github.com:satisfaction/satisfaction.git
  cd ~/Code/satisfaction/satisfaction
  successfully git submodule update --init --recursive
  successfully rvm install ree-1.8.7 --verify-downloads 1 
  successfully rvm use ree-1.8.7
  successfully rvm gemset create satisfaction
  successfully rvm gemset use satisfaction
  successfully bundle install
  successfully cp config/database.yml.dev config/database.yml
  successfully bundle exec rake sfn:development:config

fancy_echo "Setting up services project ..."
  cd ~/Code/satisfaction
  successfully git clone git@github.com:satisfaction/services.git
  cd ~/Code/satisfaction/services
  successfully git submodule update --init --recursive
  successfully rvm install ruby-2.0.0-p247
  successfully rvm use ruby-2.0.0-p247
  successfully rvm gemset create services
  successfully rvm gemset use services
  successfully bundle install

fancy_echo "Setting up ironfan-homebase ..."
  cd ~/Code/satisfaction
  successfully git clone git@github.com:satisfaction/ironfan-homebase.git
  cd ~/Code/satisfaction/ironfan-homebase
  successfully rvm install ruby-1.9.3-p194
  successfully rvm use ruby-1.9.3-p194
  successfully rvm gemset create ironfan-homebase
  successfully rvm gemset use ironfan-homebase
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
  successfully rvm use ruby-1.9.3-p448
  successfully rvm gemset create tools
  successfully rvm gemset use tools
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
