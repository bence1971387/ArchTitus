#!/usr/bin/env bash

SCRIPT_DIR="$( cd -- "$(dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

timedatectl set-ntp true
pacman -S --noconfirm pacman-contrib terminus-font
setfont ter-v22b
sed -i 's/^#Para/Para/' /etc/pacman.conf
pacman -S --noconfirm reflector grub rsync
reflector -c Hungary -a 6 --sort rate --save /etc/pacman.d/mirrorlist

echo "Enter disk (example /dev/sda)"
read DISK

sgdisk -Z ${DISK}
sgdisk -a 2048 -o ${DISK}

sgdisk -n 1::+100M --typecode=1:ef00 --change-name=1:'EFIBOOT' ${DISK}
sgdisk -n 2::-0 --typecode=2:8300 --change-name=2:'ROOT' ${DISK}

mkfs.vfat -F32 -n "EFIBOOT" "${DISK}1"
mkfs.ext4 -L "ROOT" "${DISK}2"
mount -t ext4 "${DISK}2" /mnt

pacstrap /mnt base base-devel linux linux-firmware vim sudo archlinux-keyring wget libnewt --noconfirm --needed
genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt
#cp -R ${SCRIPT_DIR} /mnt/root/ArchTitus

timedatectl set-timezone Europe/Budapest

mkdir /mnt/boot
mkdir /mnt/boot/efi
mount -t vfat -L EFIBOOT /mnt/boot/efi

grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/mnt/boot/efi
grub-mkconfig -o /mnt/boot/grub/grub.cfg

mkdir /mnt/opt/swap
dd if=/dev/zero of=/mnt/opt/swap/swapfile bs=1M count=4096 status=progress
chmod 600 /mnt/opt/swap/swapfile
chown root /mnt/opt/swap/swapfile
mkswap /mnt/opt/swap/swapfile
swapon /mnt/opt/swap/swapfile





PKGS=(
'mesa' # Essential Xorg First
'xorg'
'xorg-server'
'xorg-apps'
'xorg-drivers'
'xorg-xkill'
'xorg-xinit'
'xterm'
#'plasma-desktop' # KDE Load second
'alsa-plugins' # audio plugins
'alsa-utils' # audio utils
#'ark' # compression
#'audiocd-kio' 
'autoconf' # build
'automake' # build
'base'
'bash-completion'
'bind'
'binutils'
'bison'
#'bluedevil'
#'bluez'
#'bluez-libs'
#'bluez-utils'
#'breeze'
#'breeze-gtk'
'bridge-utils'
#'btrfs-progs'
#'celluloid' # video players
'cmatrix'
'code' # Visual Studio code
'cronie'
'cups'
'dialog'
#'discover'
#'dolphin'
'dosfstools'
'dtc'
'efibootmgr' # EFI boot
#'egl-wayland'
'exfat-utils'
'extra-cmake-modules'
#'filelight'
'flex'
'fuse2'
'fuse3'
'fuseiso'
'gamemode'
'gcc'
#'gimp' # Photo editing
'git'
#'gparted' # partition management
'gptfdisk'
'grub'
'grub-customizer'
'gst-libav'
'gst-plugins-good'
'gst-plugins-ugly'
#'gwenview'
'haveged'
'htop'
'iptables-nft'
'jdk-openjdk' # Java 17
#'kate'
#'kcodecs'
#'kcoreaddons'
#'kdeplasma-addons'
#'kde-gtk-config'
#'kinfocenter'
#'kscreen'
#'kvantum-qt5'
'kitty'
#'konsole'
#'kscreen'
'layer-shell-qt'
'libdvdcss'
'libnewt'
'libtool'
'linux'
'linux-firmware'
'linux-headers'
'lsof'
'lutris'
'lzop'
'm4'
'make'
#'milou'
#'nano'
'neofetch'
'networkmanager'
#'ntfs-3g'
'ntp'
#'okular'
'openbsd-netcat'
'openssh'
'os-prober'
#'oxygen'
'p7zip'
'pacman-contrib'
'patch'
#'picom'
'pkgconf'
#'plasma-meta'
#'plasma-nm'
#'powerdevil'
#'powerline-fonts'
#'print-manager'
'pulseaudio'
'pulseaudio-alsa'
#'pulseaudio-bluetooth'
'python-notify2'
'python-psutil'
'python-pyqt5'
'python-pip'
#'qemu'
#'rsync'
#'sddm'
#'sddm-kcm'
#'snapper'
#'spectacle'
'steam'
'sudo'
'swtpm'
#'synergy'
#'systemsettings'
#'terminus-font'
'traceroute'
'ufw'
'unrar'
'unzip'
'usbutils'
'vim'
#'virt-manager'
#'virt-viewer'
'wget'
'which'
'wine-staging'
#'wine-gecko'
#'wine-mono'
'winetricks'
#'xdg-desktop-portal-kde'
'xdg-user-dirs'
'zeroconf-ioslave'
'zip'
#'zsh'
#'zsh-syntax-highlighting'
#'zsh-autosuggestions'
'autojump'
#'awesome-terminal-fonts'
#'brave-bin' # Brave Browser
'dxvk-bin' # DXVK DirectX to Vulcan
#'github-desktop-bin' # Github Desktop sync
#'lightly-git'
#'lightlyshaders-git'
'mangohud' # Gaming FPS Counter
'mangohud-common'
#'nerd-fonts-fira-code'
#'nordic-darker-standard-buttons-theme'
#'nordic-darker-theme'
#'nordic-kde-git'
#'nordic-theme'
#'noto-fonts-emoji'
#'papirus-icon-theme'
#'plasma-pa'
#'ocs-url' # install packages from websites
#'sddm-nordic-theme-git'
#'snapper-gui-git'
#'ttf-droid'
#'ttf-hack'
#'ttf-meslo' # Nerdfont package
#'ttf-roboto'
#'zoom' # video conferences
#'snap-pac'
)
for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed
done

proc_type=$(lscpu | awk '/Vendor ID:/ {print $3}')
case "$proc_type" in
	GenuineIntel)
		print "Installing Intel microcode"
		pacman -S --noconfirm intel-ucode
		proc_ucode=intel-ucode.img
		;;
	AuthenticAMD)
		print "Installing AMD microcode"
		pacman -S --noconfirm amd-ucode
		proc_ucode=amd-ucode.img
		;;
esac	

# Graphics Drivers find and install
if lspci | grep -E "NVIDIA|GeForce"; then
    pacman -S nvidia --noconfirm --needed
	nvidia-xconfig
elif lspci | grep -E "Radeon"; then
    pacman -S xf86-video-amdgpu --noconfirm --needed
elif lspci | grep -E "Integrated Graphics Controller"; then
    pacman -S libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils --needed --noconfirm
fi
