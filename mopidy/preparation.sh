#!/bin/bash

# basé sur ce projet : https://github.com/mopidy/mopidy

# ajout clef du repo
wget -q -O - https://apt.mopidy.com/mopidy.gpg | sudo apt-key add -

# repo :
# pi 1
#wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/wheezy.list
# pi 2
wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/jessie.list

# installation
apt-get update -y -q
apt-get install -y -q build-essential python-dev python-pip gstreamer0.10-plugins-bad gstreamer0.10-plugins-good gstreamer0.10-plugins-ugly gstreamer0.10-plugins-base
#easy_install pip
easy_install-2.7 pip
sudo pip2 install --upgrade mopidy mopidy-soundcloud mopidy-dirble mopidy-dleyna mopidy-tunein mopidy-podcast mopidy-somafm mopidy-beets mopidy-podcast-itunes mopidy-scrobbler mopidy-youtube mopidy-mpris Mopidy_MFE Mopidy-AudioAddict Mopidy-Qsaver Mopidy-Mobile Mopidy-Banshee Mopidy-Notifier Mopidy-Simple-Webclient Mopidy-Moped Mopidy-InternetArchive Mopidy-Local-Images Mopidy-WebSettings Mopidy-GMusic Mopidy-MusicBox-Webclient configobj jinja2 pafy

# recherche plugins
#pip search mopidy

# ajout ipv6 module
if grep ipv6 /etc/modules
then
    echo "ipv6 deja actif"
else
    echo "ipv6" >> /etc/modules
fi

# configuration
mkdir -p /home/pi/.config/mopidy
cat <<EOF > /home/pi/.config/mopidy/mopidy.conf
[mpd]
hostname = ::
port = 6600
[http]
enabled = true
hostname = ::
port = 6680
EOF
