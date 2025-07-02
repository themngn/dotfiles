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
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
}

# Function to set up dotfiles using stow
setup_dotfiles() {
    echo "Setting up dotfiles..."
    for dir in */; do
        [[ -d "$dir" ]] && stow -R "$dir"
    done
}

# Main script execution
main() {
    # Add repositories
    add_repo "example_repo" "https://example.com/repo"

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

    echo "Installation and setup completed successfully."
}

main
