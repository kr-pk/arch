# == MY ARCH SETUP INSTALLER == #
#part1
printf '\033c'
echo "....Welcome To Kr. PK's Arch[VM] Installer Script...."
sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf
pacman -Sy archlinux-keyring
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
pacstrap /mnt base base-devel linux linux-firmware linux-headers sudo vim vi vim-runtime git wget sudo
genfstab -U -p /mnt >> /mnt/etc/fstab
sed '1,/^#part2$/d' `basename $0` > /mnt/arch_install2.sh
chmod +x /mnt/arch_install2.sh
arch-chroot /mnt ./arch_install2.sh
exit 

#part2
printf '\033c'
pacman -S sed
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
pacman -S grub
grub-install /dev/sda 
grub-mkconfig -o /boot/grub/grub.cfg

pacman -S xorg-server xorg-xinit xorg-xkill xorg-xsetroot xorg-xbacklight xorg-xprop xorg-xrandr \
	gvfs noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-hack ttf-joypixels ttf-font-awesome \
	sxiv mpv mpd mpc ncmpcpp zathura zathura-pdf-mupdf ffmpeg imagemagick \
	fzf man-db xwallpaper python-pywal yt-dlp picom unclutter xclip maim \
        zip unzip unrar tar p7zip xdotool brightnessctl \
        dosfstools ntfs-3g git sxhkd zsh pipewire pipewire-pulse \
        rsync firefox dash npm nodejs\
        picom libnotify dunst slock jq reflector \
        dhcpcd networkmanager rsync pamixer \
        zsh-syntax-highlighting zsh-completions xdg-user-dirs virtualbox-guest-utils

systemctl enable NetworkManager.service
systemctl enable vboxservice.service
rm /bin/sh
ln -s dash /bin/sh
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "Enter Username: "
read username
useradd -m -G wheel,audio,video,storage,optical,vboxsf -s /bin/zsh $username
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
mkdir $HOME/tmpdotfiles
tar -xf $HOME/dotfiles/config.tar.gz -C $HOME/tmpdotfiles/
tar -xf $HOME/dotfiles/local.tar.gz -C $HOME/tmpdotfiles/
rm -rf $HOME/.local
rsync --recursive --verbose tmpdotfiles/ $HOME/
rm -rf $HOME/dotfiles
rm -rf $HOME/tmpdotfiles
git clone https://github.com/kr-pk/pix
sudo make -C ~/.local/src/dwm install
sudo make -C ~/.local/src/st install
sudo make -C ~/.local/src/dmenu install
sudo make -C ~/.local/src/dwmblocks install
cd $HOME/.local/src/libxft-bgra-git
makepkg -si
cd $HOME/.local/src/ttf-meslo-nerd-font-powerlevel10k
makepkg -si
cd $HOME
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
