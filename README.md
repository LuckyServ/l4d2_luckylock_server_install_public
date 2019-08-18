# L4D2 Luckylock Server Install

This repository contains all the files for a clean L4D2 competitive server updated to **SourceMod 1.9.0.6281**.

# Configs

- ZoneMod 1.9.4
- Equilibrium 3.0c
- Promod Elite
- Scavhunt
- Scavogl
- OpenMod 2

# Install Steps

## Prerequisites

Login as `root` on your server, put the script below in a file named `install_pre` and run it as a bash script: `bash install_pre`.

``` bash
dpkg --add-architecture i386 # enable multi-arch
apt-get update && apt-get upgrade
apt-get install libc6:i386 # install base 32bit libraries
apt-get install lib32z1
apt-get install git
apt-get install unzip

adduser steam
usermod -aG sudo steam
```

## L4D2 Server

Login as `steam` on your server, put the script below in a file named `install_l4d2` and run it as a bash script: `bash install_l4d2`

``` bash
wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz
tar -xvzf steamcmd_linux.tar.gz
./steamcmd.sh << END_TEXT
login anonymous
force_install_dir ./Steam/steamapps/common/l4d2
app_update 222860 validate
quit
END_TEXT

echo "bind 'set completion-ignore-case on'" >> ~/.bashrc
source .bashrc

ln -s Steam/steamapps/common/l4d2/left4dead2/ l4d2

# Copy files
git clone https://github.com/LuckyServ/l4d2_luckylock_server_install_public.git
cp -r l4d2_luckylock_server_install_public/* l4d2/

ln -s l4d2/addons/sourcemod/configs/admins_simple.ini admins_simple.ini
```

## Configuration

Edit `cfg/server.cfg` to your preferences.
Edit `addons/sourcemod/configs/core.cfg` and put your own SteamID64 for `MinidumpAccount`.  
You can view your crash reports at [this website](https://crash.limetech.org/).  

## Start the server

Save this below as a file named `s` in your home directory.  

``` bash
#!/bin/bash
pkill srcds_
~/Steam/steamapps/common/l4d2/srcds_run -tickrate 100 +map "c9m1_alleys" -maxplayers 10 +sv_clockcorrection_msecs 15 -timeout 10 -port 27015 +precache_all_survivors 1 &>> servLog &
```

Type in the command `chmod u+x s`.  

To start / restart the server, simply do: `./s`.
