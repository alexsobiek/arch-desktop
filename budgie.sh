# Budige DE install & configuration script
# This is meant to be VERY similar to Ubuntu Budgie
# Needs to be run as root or with sudo

# Utility
pacman -S sudo git --noconfirm

# Budgie
pacman -S budgie-desktop budgie-screensaver --noconfirm

# LightDM
pacman -S xorg-server --noconfirm
pacman -S lightdm lightdm-slick-greeter --noconfirm
sed -i 's/#greeter-session=example-gtk-gnome/&\ngreeter-session=lightdm-slick-greeter/' /etc/lightdm/lightdm.conf
sed -i 's/#user-session=default/&\nuser-session=budgie/' /etc/lightdm/lightdm.conf
systemctl enable lightdm

# Juno Theme
cd /tmp
git clone https://github.com/EliverLara/Juno.git Juno-ocean
cd Juno-ocean
git fetch
git checkout ocean
cd
mv /tmp/Juno-ocean /usr/share/themes

# Icon Theme
cd /tmp
curl -LO https://github.com/dracula/gtk/files/5214870/Dracula.zip
bsdtar xf Dracula.zip
mv Dracula /usr/share/icons
curl -O https://upload.wikimedia.org/wikipedia/commons/a/a5/Archlinux-icon-crystal-64.svg --output-dir /usr/share/icons/

# Desktop Background
rm /usr/share/backgrounds/budgie/default.jpg
# curl https://www.teahub.io/photos/full/123-1238135_arch-linux-wallpapers-colorfull.jpg -o default.jpg
curl https://w.wallha.com/ws/12/4Ux0dIwl.png -o /usr/share/backgrounds/budgie/default.jpg

# Schema Overrides
curl -O https://raw.githubusercontent.com/alexsobiek/arch-desktop/main/budgie/budgie.gschema.override --output-dir /usr/share/glib-2.0/schemas/
mkdir -p /usr/share/budgie-desktop/layouts
curl -O https://raw.githubusercontent.com/alexsobiek/arch-desktop/main/budgie/budgie-taskbar.layout --output-dir /usr/share/budgie-desktop/layouts/
glib-compile-schemas /usr/share/glib-2.0/schemas
budgie-panel --reset --replace &

# Programs
pacman -S gnome-system-monitor gnome-control-center gnome-software gnome-software-packagekit-plugin --noconfirm
pacman -S tilix htop neofetch nautilus --noconfirm
pacman -Sy firefox-developer-edition --noconfirm

echo "if [ \$TILIX_ID ] || [ \$VTE_VERSION ]; then source /etc/profile.d/vte.sh; fi" >> /etc/bash.bashrc

# Done
systemctl reboot