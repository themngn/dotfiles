
echo "Welcome!"

echo "Installing Staff"
sudo dnf copr enable solopasha/hyprland -y
sudo dnf install stow -y 
sudo dnf install hyprland -y
sudo dnf install zsh -y
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
sudo dnf install alacritty -y
sudo dnf install rofi -y
sudo dnf install waybar -y
sudo dnf install hyprland-devel cmake meson cpio -y #Hyprpm deps
echo "Done"

echo "Creating symlinks for dotfiles"
stow nvim
stow hyprland
stow zsh
stow tmux
echo "Done"

echo "Settings"
chsh -s $(which zsh) mono
echo "Done"
