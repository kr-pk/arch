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
