#!/bin/bash

PiNAME="PiAudio"

# installation paquets nécessaires
apt-get install -y -q bluez pulseaudio-module-bluetooth python-gobject python-gobject-2 bluez-tools bluez-firmware gstreamer1.0-pulseaudio


#ajout de l'utilisateur au groupe pulseaudio 'lp'
usermod -a -G lp pi


# configuration /etc/bluetooth/audio.conf
cat <<'EOF' > /etc/bluetooth/audio.conf
[General]
Enable=Source,Sink,Media,Socket
EOF


# configuration /etc/bluetooth/main.conf
sed -i '/Name =/c\Name = $PiNAME' /etc/bluetooth/main.conf
sed -i '/Class =/c\Class = 0x20041C' /etc/bluetooth/main.conf
sed -i '/DiscoverableTimeout =/c\DiscoverableTimeout = 0' /etc/bluetooth/main.conf


# configuration /etc/pulse/daemon.conf
sed -i '/resample-method =/c\resample-method = trivial' /etc/pulse/daemon.conf
sed -i '/default-sample-channels =/c\default-sample-channels = 2' /etc/pulse/daemon.conf


# configuration /etc/pulse/system.pa
sed -i '/load-module module-udev-detect/c\load-module module-udev-detect tsched=0' /etc/pulse/system.pa
if grep ".ifexists module-bluetooth-discover.so" /etc/pulse/system.pa
then
    echo ""
else
cat <<EOF >> /etc/pulse/system.pa
.ifexists module-bluetooth-discover.so
     load-module module-bluetooth-discover
 .endif
EOF
fi

# creation /etc/udev/rules.d/99-input.rules
cp rules.d/99-input.rules /etc/udev/rules.d/99-input.rules

chmod 644 /etc/udev/rules.d/99-input.rules


# creation fichiers /etc/init.d/*
cp init.d/pulseaudio /etc/init.d/pulseaudio
cp init.d/bluetooth /etc/init.d/bluetooth
cp init.d/bluetooth-agent /etc/init.d/bluetooth-agent

chmod 755 /etc/init.d/pulseaudio
chmod 755 /etc/init.d/bluetooth
chmod 755 /etc/init.d/bluetooth-agent

update-rc.d pulseaudio defaults
update-rc.d bluetooth defaults
update-rc.d bluetooth-agent defaults


# creation fichiers /usr/local/bin/*
cp usr_local_bin/bluez-udev /usr/local/bin/bluez-udev
cp usr_local_bin/bluezutils.py /usr/local/bin/bluezutils.py
cp usr_local_bin/simple-agent.autotrust  /usr/local/bin/simple-agent.autotrust

chmod 755 /usr/local/bin/bluez-udev
chmod 755 /usr/local/bin/bluezutils.py
chmod 755 /usr/local/bin/simple-agent.autotrust


# lancer les services
service bluetooth start &
service pulseaudio start &
service bluetooth-agent start &


# activation au démarrage des services
systemctl enable bluetooth
systemctl enable pulseaudio
systemctl enable bluetooth-agent


# renaming
hciconfig hci0 name $PiNAME
