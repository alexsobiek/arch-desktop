# Installs all the needed packages to make Arch play nicely in VMware
# Requires root or sudo

pacman -S open-vm-tools --noconfirm
pacman -Su xf86-input-vmmouse xf86-video-vmware mesa --noconfirm
touch /etc/X11/Xwrapper.config
echo needs_root_rights=yes >> /etc/X11/Xwrapper.config
systemctl enable vmtoolsd
systemctl start vmtoolsd