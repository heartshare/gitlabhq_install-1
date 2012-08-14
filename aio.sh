#!/bin/sh

#essential packages, yes a lot
apt-get -y install gitolite git git-core postfix imagemagick graphicsmagick libcurl4-openssl-dev libmagickcore-dev libmagickwand-dev bison libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev autoconf libsqlite3-dev libmysqlclient-dev ttf-unifont libsasl2-dev libncurses5-dev libicu-dev mysql-server redis-server
lynx-cur build-essential

#additional packages (tools for backup monitoring and etc)
apt-get -y install p7zip-full aptitude vim htop iftop iotop smartmontools curl subversion openssl bonnie++ autossh sysv-rc-conf byobu

#get ruby (not using rvm, make it simpler)
wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p194.tar.gz
tar xvfz ruby-1.9.3-p194.tar.gz
cd ruby-1.9.3-p194
./configure && make 
make install
gem install bundler

#install gitlabhq pre
sudo adduser --system --shell /bin/sh --gecos 'git version control' --group --disabled-password --home /home/git git
su - git
ssh-keygen
exit


#configure gitolite
dpkg-reconfigure gitolite     #user: git, repo: /home/git/gitolite, key /home/git/.ssh/id_rsa.pub 

#installing gitlabhq

mkdir /www
cd /www
git clone git://github.com/gitlabhq/gitlabhq.git
cd gitlabhq && bundle install --without development test
cp -i config/database.yml.example config/database.yml
cp -i config/gitlab.yml.example config/gitlab.yml

bundle exec rake db:setup RAILS_ENV=production
bundle exec rake db:seed_fu RAILS_ENV=production

