# Voice-Engineer-Freeswitch-Assignment
#Freeswitch 1.6 install in server
#by following step install freeswitch and amd enable the modules (lua, esl)

1.INSTALL DEBAIN PACKAGES
wget -O - https://files.freeswitch.org/repo/deb/debian/freeswitch_archive_g0.pub | apt-key add -
 
echo "deb http://files.freeswitch.org/repo/deb/freeswitch-1.6/ jessie main" > /etc/apt/sources.list.d/freeswitch.list

apt-get update && apt-get install -y freeswitch-meta-all

2.Bulding from source

# Install some tools and dependencies:
apt-get install autoconf automake devscripts g++ gawk gettext git-core libcurl4-openssl-dev
libdb-dev libedit-dev libgdbm-dev 'libjpeg-dev|libjpeg62-turbo-dev' libldns-dev
libncurses5-dev libopus-dev libopus-ocaml libpcre3-dev libperl-dev libpq-dev libsndfile-dev
libspeex-dev libspeexdsp-dev libsqlite3-dev libssl-dev libtiff5-dev 'libtool-bin|libtool'
make python-dev pkg-config yasm

cd /usr/src
  
# To build from master source code:
git clone https://freeswitch.org/stash/scm/fs/freeswitch.git
 
cd /usr/src/freeswitch

# The -j argument spawns multiple threads to speed the build process 
./bootstrap.sh -j

# if you want to add or remove modules from the build, edit modules.conf
vi modules.conf
enable the mod_lua,mod_curl modules

./configure --enable-core-pgsql-support
make && make install
 
# Install audio files:
make cd-sounds-install cd-moh-install


