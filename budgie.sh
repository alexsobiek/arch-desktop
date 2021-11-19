# Budige DE install & configuration script
# This is meant to be VERY similar to Ubuntu Budgie
# Needs to be run as root or with sudo

# Utility
pacman -S git --noconfirm

# Budgie
pacman -S budgie-desktop budgie-screensaver --noconfirm

# LightDM
pacman -S xorg-server --noconfirm
pacman -S lightdm lightdm-slick-greeter --noconfirm
sed -i 's/#greeter-session=example-gtk-gnome/&\ngreeter-session=lightdm-slick-greeter/' /etc/lightdm/lightdm.conf
systemctl enable lightdm

# Juno Theme
cd /tmp
git clone https://github.com/EliverLara/Juno.git Juno-ocean
cd Juno-ocean
git fetch
git checkout ocean
cd
mv /tmp/Juno-ocean /usr/share/themes
gsettings set org.gnome.desktop.interface gtk-theme Juno-ocean
gsettings set org.gnome.desktop.wm.preferences theme Juno-ocean
gsettings set com.solus-project.budgie-panel builtin-theme false
gsettings set com.solus-project.budgie-wm button-layout close,minimize,maximize:appmenu
gsettings set org.gnome.desktop.wm.preferences button-layout close,minimize,maximize:appmenu

# Icon Theme
cd /tmp
curl -LO https://github.com/dracula/gtk/files/5214870/Dracula.zip
bsdtar xf Dracula.zip
mv Dracula /usr/share/icons
curl -O https://upload.wikimedia.org/wikipedia/commons/a/a5/Archlinux-icon-crystal-64.svg --output-dir /usr/share/icons/
gsettings set org.gnome.desktop.interface icon-theme Dracula

# Desktop Background
cd /usr/share/backgrounds
curl https://www.teahub.io/photos/full/123-1238135_arch-linux-wallpapers-colorfull.jpg -o background1.jpg
curl https://i.imgur.com/XgCwWhw.png -o background2.png
gsettings set org.gnome.desktop.background picture-uri file:////usr/share/backgrounds/background1.jpg

# Budgie Panel
cd /tmp
curl -O https://raw.githubusercontent.com/alexsobiek/arch-desktop/main/budgie/budgie-dconf
donf load /com/solus-project < budgie-donf

# Programs
pacman -S gnome-control-center gnome-software gnome-software-packagekit-plugin --noconfirm
pacman -S tilix htop neofetch nautilus --noconfirm
pacman -S firefox-developer-edition --noconfirm

# Done
systemctl reboot