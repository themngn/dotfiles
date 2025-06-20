
echo "Welcome!"

echo "Installing Staff"
sudo dnf install stow zsh hyprland -y
sudo dnf install alacritty -y
sudo dnf isntall waybar -y

echo "Installing hyprland plugins"
hyprpm add https://github.com/Duckonaut/split-monitor-workspaces
hyprpm enable split-monitor-workspaces

echo "Creating symlinks for dotfiles"
stow nvim
stow hyprland
stow zsh
echo "Done"








