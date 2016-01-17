#!/bin/bash


# installation paquets
apt-get install -y -q libupnp4 libupnp6 gmediarender gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-alsa


# configuration /etc/default/gmediarender
sed -i "/ENABLED=/c\ENABLED=1" /etc/default/gmediarender
sed -i "/UPNP_DEVICE_NAME=/c\UPNP_DEVICE_NAME=\"RaspberryPi\"" /etc/default/gmediarender
sed -i "/INITIAL_VOLUME_DB=/c\INITIAL_VOLUME_DB=0" /etc/default/gmediarender


# lancement du service
service gmediarender start &
