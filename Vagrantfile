# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
# sudo apt-get update
# sudo apt-get install -y git-core curl zlib1g-dev build-essential \
#                      libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 \
#                      libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common
# 
# cd
# git clone git://github.com/sstephenson/rbenv.git .rbenv
# echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
# echo 'eval "$(rbenv init -)"' >> ~/.bashrc
# git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
# echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
# export PATH=$PATH:/home/vagrant/.rbenv/bin/
# eval "$(rbenv init -)"
# export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
# rbenv install 2.1.2
# rbenv global 2.1.2
# echo "gem: --no-ri --no-rdoc" > /home/vagrant/.gemrc
# gem install bundler
# rbenv rehash
# 
# mysql
# sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password 111111'
# sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password 111111'
# sudo apt-get -y install mysql-server
# 
# js runtime
# sudo apt-get install -y nodejs

# apache
# sudo apt-get install -y apache2 apache2-prefork-dev libcurl4-openssl-dev libaprutil1-dev
# gem install passenger
# rbenv rehash
# passenger-install-apache2-module

sudo rm /etc/apache2/sites-enabled/000-default.conf
sudo tee -a  /etc/apache2/sites-enabled/happycasts.conf <<FILE
LoadModule passenger_module /home/vagrant/.rbenv/versions/2.1.2/lib/ruby/gems/2.1.0/gems/passenger-4.0.53/buildout/apache2/mod_passenger.so
<IfModule mod_passenger.c>
  PassengerRoot /home/vagrant/.rbenv/versions/2.1.2/lib/ruby/gems/2.1.0/gems/passenger-4.0.53
  PassengerDefaultRuby /home/vagrant/.rbenv/versions/2.1.2/bin/ruby
</IfModule>
<VirtualHost *:80>
   ServerName example.com
   DocumentRoot /vagrant/public/
   RailsEnv development
   <Directory /vagrant/public/ >
      AllowOverride all
      Options -MultiViews
   </Directory>
</VirtualHost>
FILE

sudo apachectl graceful

SCRIPT

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.provision "shell", inline: $script, privileged: false
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
  end
end
