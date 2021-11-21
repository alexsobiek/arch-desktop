# Budige DE install & configuration script
# This is meant to be VERY similar to Ubuntu Budgie
# Must be run as root!

# Utility
pacman -Syu pacman-contrib --noconfirm
curl -s "https://archlinux.org/mirrorlist/?country=US&country=CA&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 6 - > /etc/pacman.d/mirrorlist=
pacman -S sudo git networkmanager --noconfirm
systemctl enable systemd-resolved
systemctl enable NetworkManager

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
curl -LO https://codeload.github.com/matheuuus/dracula-icons/zip/refs/heads/main
bsdtar xf main
mv dracula-icons-main/ /usr/share/icons/Dracula
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
pacman -S network-manager-applet --noconfirm
pacman -S gnome-system-monitor gnome-control-center gnome-software gnome-software-packagekit-plugin --noconfirm
pacman -S tilix htop neofetch nemo --noconfirm
pacman -Sy firefox-developer-edition --noconfirm

touch /etc/xdg/autostart/nemo-desktop.desktop
printf "[Desktop Entry]\nType=Application\nExec=nemo-desktop\nHidden=false\nNoDisplay=false\nX-GNOME-Autostart-enabled=true\nName[en_US]=Nemo Desktop\nName=Nemo Desktop" > /etc/xdg/autostart/nemo-desktop.desktop

echo "if [ \$TILIX_ID ] || [ \$VTE_VERSION ]; then source /etc/profile.d/vte.sh; fi" >> /etc/bash.bashrc

# Done
systemctl reboot