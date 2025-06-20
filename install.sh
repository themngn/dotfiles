
echo "Welcome!"

echo "Installing Staff"
sudo dnf copr enable solopasha/hyprland -y
sudo dnf install stow zsh hyprland -y
sudo dnf install alacritty -y
sudo dnf isntall waybar -y
sudo dnf install hyprland-devel cmake meson cpio -y #Hyprpm deps
echo "Done"

echo "Installing hyprland plugins"
hyprpm add https://github.com/Duckonaut/split-monitor-workspaces -y
hyprpm enable split-monitor-workspaces

echo "Done"

echo "Creating symlinks for dotfiles"
stow nvim
stow hyprland
stow zsh
echo "Done"








