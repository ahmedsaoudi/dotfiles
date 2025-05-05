#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e
# Treat unset variables as an error when substituting.
set -u
# Pipelines return the exit status of the last command to exit non-zero.
set -o pipefail

# --- Configuration & Toggles ---
# Set these variables to "true" or "false" to enable/disable installation & configuration.

INSTALL_NEOVIM="true"       # Install Neovim and configure it
INSTALL_TMUX="true"         # Install Tmux and configure it
INSTALL_ROFI="true"         # Install Rofi and configure it
INSTALL_FSEARCH="true"      # Add PPA, Install Fsearch
INSTALL_PYTHON_TOOLS="true" # Install pylint, pip install black, link .pylintrc
INSTALL_NODEJS="true"       # Install NodeJS using NodeSource repository
# INSTALL_DOCKER="false"      # Install Docker engine, compose plugin, add user to group (Example: Disabled)
INSTALL_DOCKER="true"       # Install Docker engine, compose plugin, add user to group (Requires logout)
SETUP_BASH="true"         # Configure .bash_profile and .bashrc
SETUP_KEYBOARD="true"       # Setup Tunisian keyboard layout (Requires X11, logout)
SHOW_SSH_GUIDE="true"     # Display the manual SSH key restoration guide at the end

# NodeJS Version to install (e.g., 18.x, 20.x, 22.x - Check NodeSource docs for current LTS/stable)
NODE_MAJOR_VERSION="20"

# Assuming dotfiles are cloned to ~/dotfiles
DOTFILES_DIR="$HOME/dotfiles"

# --- Script Start & Checks ---
# Check if dotfiles directory exists
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Error: Dotfiles directory not found at $DOTFILES_DIR"
  echo "Please clone the repository first:"
  echo "git clone https://github.com/ahmedsaoudi/dotfiles $DOTFILES_DIR"
  exit 1
fi

# Helper Functions (info, warn, ensure_dir, link_file, add_line_to_file_if_not_exists)
info() { echo "INFO: $1"; }
warn() { echo "WARN: $1"; }
ensure_dir() { mkdir -p "$1"; info "Ensured directory exists: $1"; }
link_file() { local src="$1"; local dest="$2"; ln -sf "$src" "$dest"; info "Linked $src -> $dest"; }
add_line_to_file_if_not_exists() {
    local line="$1"; local file="$2"
    if ! grep -qxF "$line" "$file"; then echo "$line" >> "$file"; info "Added line to $file: $line";
    else info "Line already exists in $file: $line"; fi
}

# --- Base System Update and Core Package Installation ---
info "Updating package lists..."
sudo apt-get update

info "Installing core essential packages..."
# Includes prerequisites for NodeSource (curl, gpg) and Docker (curl, gpg).
sudo apt-get install -y \
  git \
  curl \
  build-essential \
  cmake \
  ca-certificates \
  gnupg \
  gpg \
  xclip \
  wl-clipboard \
  fonts-hack \
  python3-pip \
  htop \
  gnome-sushi \
  ubuntu-restricted-extras \
  python3-dev

# --- Conditional Installations and Configurations ---

# --- Fsearch ---
if [ "$INSTALL_FSEARCH" = true ]; then
  info "--- Setting up Fsearch ---"
  sudo add-apt-repository -yn ppa:christian-boxdoerfer/fsearch-daily
  sudo apt-get update # Update needed after adding PPA
  sudo apt-get install -y fsearch-trunk
else
    info "--- Skipping Fsearch ---"
fi

# --- Python Tools ---
if [ "$INSTALL_PYTHON_TOOLS" = true ]; then
  info "--- Setting up Python Tools ---"
  sudo apt-get install -y pylint
  pip3 install --user black
  link_file "$DOTFILES_DIR/.pylintrc" "$HOME/.pylintrc"
else
    info "--- Skipping Python Tools Setup ---"
fi

# --- Neovim ---
if [ "$INSTALL_NEOVIM" = true ]; then
  info "--- Setting up Neovim ---"
  sudo apt-get install -y neovim

  NVIM_CONFIG_DIR="$HOME/.config/nvim"
  NVIM_PLUG_FILE="$HOME/.local/share/nvim/site/autoload/plug.vim"
  ensure_dir "$NVIM_CONFIG_DIR"
  link_file "$DOTFILES_DIR/init.vim" "$NVIM_CONFIG_DIR/init.vim"

  info "Installing vim-plug..."
  if [ ! -f "$NVIM_PLUG_FILE" ]; then
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim \
      --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    info "vim-plug installed."
  else info "vim-plug already exists."; fi

  info "Installing Neovim plugins..."
  nvim --headless +PlugInstall +qall
else
    info "--- Skipping Neovim Setup ---"
fi

# --- Tmux ---
if [ "$INSTALL_TMUX" = true ]; then
  info "--- Setting up Tmux ---"
  sudo apt-get install -y tmux

  TMUX_PLUGIN_DIR="$HOME/.tmux/plugins/tpm"
  link_file "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"

  info "Installing Tmux Plugin Manager (TPM)..."
  if [ ! -d "$TMUX_PLUGIN_DIR" ]; then
    git clone --depth 1 https://github.com/tmux-plugins/tpm "$TMUX_PLUGIN_DIR"; info "TPM cloned."
  else info "TPM directory already exists."; fi

  info "Installing Tmux plugins via TPM..."
  # Ensure TPM executable exists before running
  if [ -x "$TMUX_PLUGIN_DIR/bin/install_plugins" ]; then
      "$TMUX_PLUGIN_DIR/bin/install_plugins"
  else
      warn "TPM install script not found or not executable at $TMUX_PLUGIN_DIR/bin/install_plugins"
  fi
else
    info "--- Skipping Tmux Setup ---"
fi

# --- Rofi ---
if [ "$INSTALL_ROFI" = true ]; then
  info "--- Setting up Rofi ---"
  sudo apt-get install -y rofi

  ROFI_CONFIG_DIR="$HOME/.config/rofi"
  ensure_dir "$ROFI_CONFIG_DIR"
  link_file "$DOTFILES_DIR/rofi/config" "$ROFI_CONFIG_DIR/config"
else
    info "--- Skipping Rofi Setup ---"
fi

# --- NodeJS (using NodeSource) ---
if [ "$INSTALL_NODEJS" = true ]; then
  info "--- Installing NodeJS v${NODE_MAJOR_VERSION}.x using NodeSource ---"
  # Ensure prerequisites are installed (curl, gpg - should be covered by core install)
  # Setup NodeSource repository
  KEYRING_DIR=/etc/apt/keyrings
  sudo mkdir -p "$KEYRING_DIR"
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o "$KEYRING_DIR/nodesource.gpg"
  echo "deb [signed-by=$KEYRING_DIR/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR_VERSION.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list

  # Update package list after adding repo and install nodejs
  sudo apt-get update
  sudo apt-get install nodejs -y # Installs nodejs and npm
else
    info "--- Skipping NodeJS Installation ---"
fi

# --- Shell Configuration (Bash) ---
if [ "$SETUP_BASH" = true ]; then
  info "--- Configuring Bash ---"
  link_file "$DOTFILES_DIR/.bash_profile" "$HOME/.bash_profile"
  add_line_to_file_if_not_exists "source ~/.bash_profile" "$HOME/.bashrc"
else
    info "--- Skipping Bash Configuration ---"
fi

# --- Tunisian Keyboard Layout ---
if [ "$SETUP_KEYBOARD" = true ]; then
  info "--- Setting up Tunisian Keyboard Layout (X11) ---"
  KEYBOARD_SRC_DIR="$HOME/dotfiles/tn_keyboard_src"
  KEYBOARD_DEST_DIR="/usr/share/X11/xkb/symbols"
  KEYBOARD_SYMBOL_FILE="tn"
  ensure_dir "$KEYBOARD_SRC_DIR"
  if [ ! -d "$KEYBOARD_SRC_DIR/.git" ]; then
      git clone https://github.com/ahmedsaoudi/klavietn "$KEYBOARD_SRC_DIR"
  else info "Keyboard layout source already cloned."; fi
  sudo ln -sf "$KEYBOARD_SRC_DIR/$KEYBOARD_SYMBOL_FILE" "$KEYBOARD_DEST_DIR/$KEYBOARD_SYMBOL_FILE"
  warn "Tunisian keyboard layout linked for X11. Log out/in or configure input sources."
else
    info "--- Skipping Tunisian Keyboard Setup ---"
fi

# --- Docker Installation ---
if [ "$INSTALL_DOCKER" = true ]; then
  info "--- Setting up Docker ---"
  # 1. Set up the repository (includes prerequisites check implicit via apt)
  sudo apt-get update
  sudo install -m 0755 -d /etc/apt/keyrings
  if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
      sudo chmod a+r /etc/apt/keyrings/docker.gpg
  else info "Docker GPG key already exists."; fi
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update # Update after adding Docker repo

  # 2. Install Docker packages
  info "Installing Docker packages..."
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  # 3. Add user to the docker group
  info "Adding current user ($USER) to the docker group..."
  # Check if user is already in group to avoid unnecessary messages/errors
  if ! groups "$USER" | grep -q '\bdocker\b'; then
      sudo usermod -aG docker "$USER"
      warn "User $USER added to the docker group. Log out/in required."
  else
      info "User $USER is already in the docker group."
  fi
else
    info "--- Skipping Docker Installation & Setup ---"
fi


# --- Final Reminder: Manual SSH Key Restoration ---
if [ "$SHOW_SSH_GUIDE" = true ]; then
    YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
    echo -e "\n${YELLOW}====================================================="
    echo -e "  ACTION REQUIRED: Manual SSH Key Restoration"
    # ... (rest of SSH guide) ...
    echo -e "=====================================================${NC}"
    echo -e "The automated setup is complete. To fully restore SSH access"
    echo -e "(e.g., for private git repositories), follow these steps:"
    echo ""
    echo -e "1. ${YELLOW}Connect${NC} your USB drive or external storage containing your '.ssh' backup."
    echo ""
    echo -e "2. ${YELLOW}Copy${NC} the files from your backup into the '~/.ssh' directory."
    echo -e "   You might need to create the directory first. Example commands:"
    echo -e "   (Adjust the source path '/path/to/your/backup/.ssh/' accordingly)"
    echo -e "${CYAN}"
    echo "mkdir -p ~/.ssh"
    echo "cp /path/to/your/backup/.ssh/* ~/.ssh/"
    echo -e "${NC}"
    echo -e "3. ${YELLOW}Set Permissions${NC}: Copy the entire block of commands below and paste it into your terminal:"
    echo -e "${CYAN}#---Begin Permissions Block---"
    echo "chmod 700 ~/.ssh"
    echo "chmod 600 ~/.ssh/id_rsa"
    echo "# Add lines like 'chmod 600 ~/.ssh/your_other_private_key' if needed"
    echo "chmod 644 ~/.ssh/id_rsa.pub"
    echo "chmod 644 ~/.ssh/known_hosts"
    echo "chmod 600 ~/.ssh/config"
    echo -e "#---End Permissions Block---${NC}"
    echo ""
    echo -e "4. ${YELLOW}Test${NC} your SSH connection, for example:"
    echo -e "   ${CYAN}ssh -T git@github.com${NC}"
    echo -e "${YELLOW}=====================================================${NC}\n"

else
    info "--- Skipping SSH Restore Guide Display ---"
fi

# --- Setup Complete ---
info "--- Setup Script Finished ---"
warn "Please review the output for any errors or warnings."
REBOOT_NEEDED=false
if ([ "$INSTALL_DOCKER" = true ] || [ "$SETUP_KEYBOARD" = true ]); then
    REBOOT_NEEDED=true
fi

if [ "$REBOOT_NEEDED" = true ]; then
     warn "REMINDER: A logout/login or reboot is required for some changes (Docker group, Keyboard) to apply fully."
fi

# End of script
