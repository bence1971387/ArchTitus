#!/usr/bin/env python3

import subprocess
import os.path

security = """
ufw fail2ban arch-audit
"""

vst_plugins = """
fil-plugins freeverb3 frei0r-plugins wolf-shaper wolf-spectrum calf lsp-plugins zam-plugins
wah-plugins tap-plugins swh-plugins rev-plugins mcp-plugins dpf-plugins dragonfly-reverb eq10q
"""

audio_utilities = """
a2jmidi qjackctl jack2 pulseaudio-jack jack_capture jack-keyboard reaper
"""

drivers = """
lib32-mesa mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader
"""

gaming = """
wine-staging legendary lutris gamemode-git lib32-gamemode-git steam mangohud lib32-mangohud
""" 

#giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls
#mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse
#libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib
#libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite
#libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader
#lib32-opencl-icd-loader libxslt lib32-libxsltlibva lib32-libva gtk3 lib32-gtk3
#gst-plugins-base-libs lib32-gst-plugins-base-libs
#legendary lutris gamemode-git lib32-gamemode-git steam mangohud lib32-mangohud performance-tweaks
#"""

shell = """
zsh
"""

university = """
teams discord virtualbox
"""

java = """
jdk-openjdk jre-openjdk
"""

themes = """
arc-gtk-theme zsh-theme-powerlevel10k-git
"""

theming_utilities = """
kvantum-qt5 lxappearance qt5ct
"""

fonts = """
awesome-terminal-fonts figlet-fonts-extra
ttf-font-awesome ttf-dejavu ttf-iosevka ttf-iosevka-nerd
"""

ricing = """
python-pywal lolcat neofetch figlet compton-tyrone-git font-manager feh xdotool
"""

additional = """
aseprite workflowy pureref godot brave p7zip p7zip-plugins unrar tar vlc
"""

codecs = """
a52dec faac faad2 flac jasper lame libdca libdv libmad libmpeg2 libtheora libvorbis libxv 
wavpack x264 xvidcore
"""

packages = security + " " + vst_plugins + " " + audio_utilities + " " + drivers + " " + gaming + " " + shell + " " + university + " " + java + " " + themes + " " + theming_utilities + " " + fonts + " " + ricing + " " + additional + " " + codecs

packages = packages.split()

def todoafter():
  print('''
  vim /etc/security/limits.conf
  @audio - rtprio 99
  @audio - memlock unlimited

  systemctl enable paccache.timer
  systemctl start paccache.timer
  paccache -rk1

  reflector -c Hungary -a 6 --sort rate --save /etc/pacman.d/mirrorlist

  install and select theme in kvantum-qt5
  select gtk theme in lxappearance

  select kvantum theme in qt5ct and apply it to apps
  ''')

def freetype():
  file_exists = os.path.exists('/etc/profile.d/freetype2.sh')
  print(file_exists)

def nobit_subpixrgb_lcdfilter():
  print(os.path.islink('/etc/fonts/conf.d/70-no-bitmaps.conf'))
  print(os.path.islink('/etc/fonts/conf.d/10-sub-pixel-rgb.conf'))
  print(os.path.islink('/etc/fonts/conf.d/11-lcdfilter-default.conf'))

def main():
  #nobit_subpixrgb_lcdfilter()
  #security_limits()
  #print(packages)
  #todoafter()
  print(packages)
  a = subprocess.call(['yay','-S'] + packages)

if __name__ == "__main__":
  main()
