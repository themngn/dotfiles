
echo "Welcome!"

echo "Installing Staff"
sudo dnf copr enable solopasha/hyprland -y > /dev/null
sudo dnf install stow -y > /dev/null 
sudo dnf install hyprland -y > /dev/null
sudo dnf install zsh -y > /dev/null
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
sudo dnf install alacritty -y > /dev/null
sudo dnf install rofi -y > /dev/null
sudo dnf install waybar -y > /dev/null
sudo dnf install hyprland-devel cmake meson cpio -y > /dev/null #Hyprpm deps
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
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
