
echo "Welcome!"

echo "Installing Staff"
sudo dnf install stow zsh hyprland -y
sudo dnf install alacritty -y
sudo dnf isntall waybar -y

echo "Creating symlinks for dotfiles"
stow nvim
stow hyprland
stow zsh
echo "Done"








