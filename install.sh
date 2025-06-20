
echo "Welcome!"

echo "Installing Staff"
sudo dnf install stow zsh

echo "Creating symlinks for dotfiles"
stow nvim
stow hyprland
stow zsh
echo "Done"








