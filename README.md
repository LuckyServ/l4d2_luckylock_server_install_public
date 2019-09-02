# L4D2 Luckylock Server Install

This repository contains all the files for a clean L4D2 competitive server updated to **SourceMod 1.9.0.6281**. It contains files from the [L4D2 Competitive Rework](https://github.com/SirPlease/L4D2-Competitive-Rework) but the missing / broken plugins have been fixed. It also contains a few extra features such as:

- Installation steps (below)
- Automatic server restart after every game (you can do a manual restart with `!rs`)
- Advanced crash logs thanks to [Accelerator](https://forums.alliedmods.net/showthread.php?t=277703&)
- `!mix` command for team selection (`!stopmix` to stop the mix process at any time)
- Ready-up menu that doesn't completely hide the chat
- Extra configs (hit me up if you want me to add your config to this)
- Easy custom maps installation (bottom of this README)

## Configs

- NextMod 1.0.2
- ZoneMod 1.9.4
- Apex 1.1.2
- Equilibrium 3.0c
- Promod Elite 1.1
- OpenMod 2
- Scavhunt
- Scavogl
- HardCoop

## Install Steps

First of all, make sure your server is running **Ubuntu 18.04** or earlier. A L4D2 server on Ubuntu 19 is glitchy (you will see blood coming out of your screen when you shoot commons from far).  

### 1) Installing Prerequisites

Login as `root` on your server, put the script below in a file named `install_pre` and run it as a bash script: `bash install_pre`.

``` bash
# Install prerequisites
dpkg --add-architecture i386 # enable multi-arch
apt-get update -y && apt-get upgrade -y
apt-get install -y libc6:i386 # install base 32bit libraries
apt-get install -y lib32z1
apt-get install -y git
apt-get install -y unzip

# Create user account
adduser steam
usermod -aG sudo steam
```

### 2) Install the L4D2 Server

Login as `steam` on your server, put the script below in a file named `install_l4d2` and run it as a bash script: `bash install_l4d2`

``` bash
# Install base game
wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz
tar -xvzf steamcmd_linux.tar.gz
./steamcmd.sh << END_TEXT
login anonymous
force_install_dir ./Steam/steamapps/common/l4d2
app_update 222860 validate
quit
END_TEXT

# Personal preference for auto-completion
echo "bind 'set completion-ignore-case on'" >> ~/.bashrc
source .bashrc

# Setup main l4d2 shortcut
ln -s Steam/steamapps/common/l4d2/left4dead2/ l4d2

# Install files from this repository
git clone https://github.com/LuckyServ/l4d2_luckylock_server_install_public.git
cp -r l4d2_luckylock_server_install_public/* l4d2/

# Setup useful shortcuts
ln -s l4d2/addons/sourcemod/configs/admins_simple.ini admins_simple.ini
ln -s l4d2/addons/sourcemod/plugins/ plugins
ln -s l4d2/addons/sourcemod/configs/matchmodes.txt matchmodes.txt

# Create server start / restart script
printf "%s\n" \
"#!/bin/bash" \
"pkill -9 srcds_" \
"~/Steam/steamapps/common/l4d2/srcds_run -tickrate 100 +map "c9m1_alleys" +sv_clockcorrection_msecs 15 -timeout 10 -port 27015 +precache_all_survivors 1 &>> servLog &" \
> s
chmod u+x s

# Create server update script
printf "%s\n" \
"#!/bin/bash" \
"pkill -9 srcds_" \
"cd ~/l4d2_luckylock_server_install_public" \
"git pull" \
"rm myhost.txt" \
"rm mymotd.txt" \
"rm cfg/server.cfg" \
"rm addons/sourcemod/configs/admins_simple.ini" \
"rm addons/sourcemod/configs/core.cfg" \
"rm -rf ../l4d2/addons/sourcemod/plugins/" \
"rm -rf ../l4d2/cfg/cfgogl/" \
"cp -r * ../l4d2/" \
"git reset HEAD --hard" \
"cd ~" \
"./s" \
> update
chmod u+x update
```

### 3) Edit Configuration Files

- Edit `l4d2/cfg/server.cfg` to your preferences.  
- Edit `l4d2/addons/sourcemod/configs/core.cfg` and put your own SteamID64 for `MinidumpAccount`. You can view your crash reports at [this website](https://crash.limetech.org/).
- Edit `l4d2/addons/sourcemod/config/admins_simple.ini` and add yourself as admin instead of me.

### 4) Start the Server

To start / restart the server, simply do: `./s`

### 5) Install Custom Maps (optional)

Navigate to your addons folder: `cd l4d2/addons`, put the script below in a file named `install_maps` and run it as a background job: `bash install_maps &`. This allows you to terminate the SSH connection and the job will still complete.

``` bash
wget http://192.223.24.83/AllMapsInOneZipFile.zip
unzip AllMapsInOneZipFile.zip -d .
rm -f AllMapsInOneZipFile.zip
```

## Update your servers to the latest version

Login as `steam` on your server and run the `update` script: `bash update`
