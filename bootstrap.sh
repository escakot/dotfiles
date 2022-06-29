#!/bin/bash

set -e

# Colours to use
RED='\033[0;31m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
CLEAR='\033[0m'

# Helper functions for logging

info() {
    printf "${CYAN}INFO: ${CLEAR}$1\n"
}

success() {
    printf "${GREEN}OK: ${CLEAR}$1\n"
}

fail() {
    printf "${RED}ERROR: ${CLEAR}$1\n"
    exit 1
}

# Environment Check
if [[ $USER == 'root' ]]; then
    fail "Don't run this script as root"
fi
if [[ "$OSTYPE" != "darwin"* ]]; then
    fail 'Unsupported OS. Only macOS is supported.'
fi

rootdir=$(git rev-parse --show-toplevel | tr -d '\n')

# Check if brew is installed
info "Checking if ${CYAN}homebrew${CLEAR} is installed..."

export PATH=/opt/homebrew/bin:$PATH
if ! command -v brew >/dev/null; then
    info "Installing ${CYAN}homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    success "Successfully installed ${CYAN}homebrew"
else
    info "${CYAN}homebrew${CLEAR} is already installed!"
fi

# Install from Brewfile
info "Installing brew packages..."
brew bundle --no-lock || true

# Install oh-my-zsh
info "Checking ${CYAN}oh-my-zsh"

if [[ -d "$HOME/.oh-my-zsh" ]]; then
    info "${CYAN}oh-my-zsh${CLEAR} is already installed!"
else
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    success "Successfully installed ${CYAN}oh-my-zsh"
fi
cp ./zsh/zshrc "$HOME/.zshrc"

# Configure git
cp ./git/gitconfig "$HOME/.gitconfig"

# Configure vim
info "Configuring ${CYAN}Vim"
sh -c "$(curl -sLf https://spacevim.org/install.sh)"

# Configuring macOS defaults
info "Configuring ${CYAN}macOS defaults"
./macos/defaults.sh

# Configuring VSCode
info "Copying ${CYAN}VSCode settings"
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
mkdir -p "$HOME/Library/Application Support/Code/User"
cp ./vscode/settings.json "$HOME/Library/Application Support/Code/User/settings.json"
if ! command -v code >/dev/null; then
    info "${CYAN}code${CLEAR} command is not installed, please install it before continuing"
    read -r -p "Press enter to continue"
fi

info "Installing VSCode extensions"
while IFS= read -r ext; do
    code --install-extension "$ext"
done <<<"$(cat ./vscode/Codefile)"

info "Importing Xcode UserData"
ln -s "$rootdir/xcode/Templates" "$HOME/Library/Developer/Xcode/Templates"

success "All done. Enjoy!"
