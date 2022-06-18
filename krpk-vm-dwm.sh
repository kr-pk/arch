printf '\033c'
echo "\n....Welcome To Kr. PK's DWM Installer Script For ARCH....\n"

sudo pacman -S xorg-server xorg-xinit xorg-xkill xorg-xsetroot xorg-xbacklight xorg-xprop xorg-xrandr \
	gvfs noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-hack ttf-joypixels ttf-font-awesome \
	sxiv mpv mpd ncmpcpp zathura zathura-pdf-mupdf ffmpeg imagemagick  \
	fzf man-db xwallpaper python-pywal yt-dlp picom unclutter xclip maim \
        zip unzip unrar tar p7zip xdotool brightnessctl  \
        dosfstools ntfs-3g git sxhkd zsh pipewire pipewire-pulse \
        rsync firefox dash npm nodejs\
        picom libnotify dunst slock jq reflector \
        dhcpcd networkmanager rsync pamixer \
        zsh-syntax-highlighting zsh-completions zsh-autosuggestions xdg-user-dirs virtualbox-guest-utils

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
