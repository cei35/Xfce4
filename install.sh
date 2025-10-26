#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <user>"
    exit 1
fi

user="$1"
USER_HOME="/home/$user"
XFCE_TEMPLATE_DIR="/usr/share/xfce4/default-config"
localectl set-x11-keymap fr

# Install - (add code, libreoffice, librewolf-bin, keepassxc, virtualbox)
pacman -Sy --noconfirm xfce4 materia-gtk-theme papirus-icon-theme lightdm lightdm-gtk-greeter network-manager-applet pavucontrol xfce4-screenshooter \
xfce4-taskmanager xfce4-power-manager file-roller thunar-archive-plugin mousepad ristretto evince xfce4-systemload-plugin xfce4-screensaver \
xfce4-wavelan-plugin xfce4-weather-plugin xfce4-pulseaudio-plugin xfce4-battery-plugin plank ttf-jetbrains-mono-nerd noto-fonts-emoji \
code libreoffice-fresh keepassxc virtualbox xfce4-terminal || { echo "Error : $@"; exit 1; }

# LibreWolf (AUR if yay is installed)
if command -v yay &> /dev/null; then
    sudo -u "$user" yay -S --noconfirm librewolf-bin || { echo "Error installing librewolf-bin"; exit 1; }
fi

# Background (missing implementation)
mkdir -p /usr/share/backgrounds
wget -O /usr/share/backgrounds/back.jpg https://raw.githubusercontent.com/cei35/Hyprland/main/back.jpg

# Plank
PLANK_DIR="$USER_HOME/.config/plank/dock1/launchers"
mkdir -p "$PLANK_DIR"

dockitem_file() {
    local app="$1"
    cat > "$PLANK_DIR/$app.dockitem" <<EOF
[PlankDockItemPreferences]
Launcher=file:///usr/share/applications/$app.desktop
EOF
}

apps=( "code-oss" "librewolf" "libreoffice-writer" "org.keepassxc.KeePassXC" "org.xfce.mousepad" "thunar" "virtualbox" "xfce4-terminal" )

for app in "${apps[@]}"; do
    dockitem_file "$app"
done

# Autostart Plank
AUTOSTART_DIR="$USER_HOME/.config/autostart"
mkdir -p "$AUTOSTART_DIR"
cat > "$AUTOSTART_DIR/plank.desktop" <<EOF
[Desktop Entry]
Encoding=UTF-8
Version=0.9.4
Type=Application
Name=plank
Comment=plank
Exec=plank
OnlyShowIn=XFCE;
RunHook=0
StartupNotify=false
Terminal=false
Hidden=false
EOF

INT=$(ip -o -4 addr show | awk 'NR==2 {print $2}')
[ -z "$INT" ] && INT="wlan0"
echo "Interface=$INT" > /etc/xdg/xfce4/panel/wavelan-24.rc

# Backup + new config XFCE
mv /etc/xdg/xfce4/panel/default.xml{,.bak} 2>/dev/null || true
cp xfce4_panel.xml /etc/xdg/xfce4/panel/default.xml

mv /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml{,.bak} 2>/dev/null || true
cp xfce4_keyboards.xml /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml

mv /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml{,.bak} 2>/dev/null || true
cp xfce4_settings.xml /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml

# LightDM
mv /etc/lightdm/lightdm-gtk-greeter.conf{,.bak} 2>/dev/null || true
cat > /etc/lightdm/lightdm-gtk-greeter.conf <<EOF
[greeter]
background=/usr/share/backgrounds/back.jpg
theme-name=Materia-dark
icon-theme-name=Papirus
EOF
systemctl enable lightdm

# Create user config dir
mkdir -p "$USER_HOME/.config/xfce4"
chown -R "$user:$user" "$USER_HOME/.config/xfce4"

chown -R "$user:$user" "$USER_HOME/.config"
chown -R "$user:$user" "$USER_HOME/.cache"