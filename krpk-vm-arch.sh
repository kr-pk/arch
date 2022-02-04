# == MY ARCH SETUP INSTALLER == #
#part1
printf '\033c'
echo "....Welcome To Kr. PK's Arch[VM] Installer Script...."
sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf
pacman --noconfirm -Sy archlinux-keyring
loadkeys us
timedatectl set-ntp true
lsblk
echo "\nNote: This Installer Script Is For VM[Virtual Box OR VMWare]....\n"
echo "Enter The Drive: "
read drive
cfdisk $drive 
echo "Enter The Linux Partition: "
read partition
mkfs.ext4 $partition 
read -p "Did you also created swap partition? [y/n]" answerswap
if [[ $answerswap = y ]] ; then
  echo "Enter SWAP Partition: "
  read swappartition
  mkswap $swappartition
  swapon $swappartition
fi
mount $partition /mnt 
pacstrap /mnt base base-devel linux linux-firmware sudo vim vi vim-runtime git wget sudo
genfstab -U -p /mnt >> /mnt/etc/fstab
sed '1,/^#part2$/d' `basename $0` > /mnt/arch_install2.sh
chmod +x /mnt/arch_install2.sh
arch-chroot /mnt ./arch_install2.sh
exit 

#part2
printf '\033c'
pacman -S --noconfirm sed
sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
timedatectl set-ntp true
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "LC_CTYPE=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf
echo "Hostname: "
read hostname
echo $hostname > /etc/hostname
echo "127.0.0.1       localhost" >> /etc/hosts
echo "::1             localhost" >> /etc/hosts
echo "127.0.1.1       $hostname.localdomain $hostname" >> /etc/hosts
mkinitcpio -P
passwd
pacman --noconfirm -S grub
grub-install /dev/sda 
grub-mkconfig -o /boot/grub/grub.cfg

pacman -S --noconfirm xorg-server xorg-xinit xorg-xkill xorg-xsetroot xorg-xbacklight xorg-xprop \
     gvfs mc noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-jetbrains-mono ttf-joypixels ttf-font-awesome \
     sxiv mpv vlc zathura zathura-pdf-mupdf ffmpeg imagemagick  \
     fzf man-db xwallpaper python-pywal youtube-dl picom unclutter xclip maim \
     zip unzip unrar tar p7zip xdotool brightnessctl  \
     dosfstools ntfs-3g git sxhkd zsh pipewire pipewire-pulse \
     emacs rsync firefox dash \
     libnotify dunst slock jq \
     dhcpcd networkmanager rsync pamixer \
     zsh-syntax-highlighting xdg-user-dirs virtualbox-guest-utils

systemctl enable NetworkManager.service 
rm /bin/sh
ln -s dash /bin/sh
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "Enter Username: "
read username
useradd -m -G wheel,audio,video,storage,optical -s /bin/zsh $username
passwd $username

ai3_path=/home/$username/arch_install3.sh
sed '1,/^#part3$/d' arch_install2.sh > $ai3_path
chown $username:$username $ai3_path
chmod +x $ai3_path
su -c $ai3_path -s /bin/sh $username
exit 

#part3
printf '\033c'
cd $HOME
git clone --separate-git-dir=$HOME/.dotfiles https://github.com/kr-pk/dotfiles.git
mv -f ~/dotfiles/dotfiles.tar.gz $HOME/
mkdir $HOME/tmpdotfiles
tar -xf dotfiles.tar.gz $HOME/tmpdotfiles/
rm -rf $HOME/.local
rsync --recursive --verbose tmpdotfiles/ $HOME/
rm -rf $HOME/dotfiles.tar.gz
rm -rf $HOME/dotfiles
rm -rf $HOME/tmpdotfiles
git clone https://github.com/kr-pk/dwm $HOME/docs
git clone https://github.com/kr-pk/pix
git clone --depth=1 https://git.suckless.org/dwm
sudo make -C ~/dwm install
sudo make -C ~/.local/src/st install
sudo make -C ~/.local/src/dmenu install
sudo make -C ~/.local/src/dwmblocks install
git clone --depth=1 https://github.com/Bugswriter/baph.git ~/.local/src/baph
sudo make -C ~/.local/src/baph install
baph -inN libxft-bgra-git
ln -s ~/.config/x11/xinitrc .xinitrc

#Install ZSH....
ln -s ~/.config/shell/profile .zprofile
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
mv ~/.oh-my-zsh ~/.config/zsh/oh-my-zsh
rm ~/.zshrc ~/.zsh_history

#.git conifiguration to save his dotfiles to /home/.dotfiles....
alias dots='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dots config --local status.showUntrackedFiles no
exit
