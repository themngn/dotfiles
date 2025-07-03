#!/bin/bash

# Function to handle errors
handle_error() {
    echo "An error occurred at line $1. Exiting."
    exit 1
}

# Trap errors
TRAPERR() {
    handle_error $LINENO
}

if [[ $EUID -eq 0 ]]; then
	echo "This script should not be run as root. Please run it as a regular user."
	exit 1
fi

# Ask for sudo password once
echo "Please enter your sudo password:"
sudo -v

# Keep-alive: update existing `sudo` timestamp until the script finishes
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

# Function to add a repository
add_repo() {
    local repo_name=$1
    local repo_url=$2
    if ! sudo dnf -y list enabled | grep -q "$repo_name"; then
        echo "Adding repository: $repo_name"
        sudo dnf config-manager --add-repo "$repo_url"
    else
        echo "Repository $repo_name already exists."
    fi
}

# Function to install packages using dnf
install_dnf_packages() {
    echo "Installing dnf packages from packages.txt..."
    if [[ ! -f packages.txt ]]; then
        echo "Error: packages.txt not found."
        exit 1
    fi

    local packages=()
    while IFS= read -r line; do
        [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue  # Skip comments/empty lines
        packages+=("$line")
    done < packages.txt

    sudo dnf install -y "${packages[@]}"
}

# Function to install Homebrew
install_homebrew() {
    echo "Installing Homebrew..."
	export NONINTERACTIVE=1
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
    source ~/.zshrc
}

# Function to install atuin
install_atuin() {
    echo "Installing atuin..."
    /bin/bash -c "$(curl -fsSL https://setup.atuin.sh)"
}

# Function to install zinit
install_zinit() {
    echo "Installing zinit..."
	export NO_INPUT=1
	export NO_EDIT=1
	export NO_ANNEXES=1
	export NO_TUTORIAL=1
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
}

# Function to set up dotfiles using stow
setup_dotfiles() {
    echo "Setting up dotfiles..."
	stow nvim
	stow tmux
	stow hyprland
	mv ~/.zshrc ~/.zshrc_back_$(date +%Y%m%d_%H%M%S)
	stow zsh
}

#Change shell to zsh
change_shell_to_zsh() {
	echo "Changing shell to zsh..."
	USER_NAME="$(whoami)"
	if [[ -z "$USER_NAME" ]]; then
		echo "Error: Unable to determine the current user."
		exit 1
	fi
	sudo usermod -s "$(which zsh)" "$USER_NAME"
}

# Main script execution
main() {
    # Add repositories
    # add_repo "example_repo" "https://example.com/repo"
    sudo dnf copr enable solopasha/hyprland -y > /dev/null


    # Install dnf packages
    install_dnf_packages

    # Install Homebrew
    install_homebrew

    # Install atuin
    install_atuin

    # Install zinit
    install_zinit

    # Set up dotfiles
    setup_dotfiles

	# Change shell to zsh
	change_shell_to_zsh
    echo "Installation and setup completed successfully."
}

main
