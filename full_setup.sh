#!/bin/bash

# File: setup_full.sh
# Description: Full initial setup for Debian/Ubuntu systems with custom zsh config

LOGFILE="/var/log/setup_full.log"
exec > >(tee -a "$LOGFILE") 2>&1

echo "----------------------------------------"
echo "[`date`] Starting full system setup..."
echo "----------------------------------------"

# Update and install core utilities
apt update && apt upgrade -y
apt install -y \
    software-properties-common apt-transport-https curl wget gnupg lsb-release ca-certificates \
    sudo htop git unzip zip screen tmux ufw bash-completion nano vim \
    net-tools iputils-ping dnsutils traceroute \
    build-essential python3 python3-pip python3-venv \
    zsh emacs-nox samba

# Set timezone and locale
timedatectl set-timezone Europe/Berlin
locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8

# Firewall configuration
ufw allow OpenSSH
ufw --force enable

# Disable root login over SSH
sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl restart sshd

# Install Oh My Zsh
export RUNZSH=no
export CHSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install plugins
ZSH_CUSTOM="/root/.oh-my-zsh/custom"
cd "$ZSH_CUSTOM/plugins"
git clone https://github.com/zsh-users/zsh-autosuggestions.git
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git
git clone https://github.com/marlonrichert/zsh-autocomplete.git

# Modify .zshrc
cat > /root/.zshrc << 'EOF'
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="bira"

# Auto-update reminder
zstyle ':omz:update' mode reminder
zstyle ':omz:update' frequency 7

# Enable command auto-correction
ENABLE_CORRECTION="true"

# History timestamp format
HIST_STAMPS="dd/mm/yyyy"

# Plugin list
plugins=(
  git
  git-extras
  screen
  zsh-autosuggestions
  zsh-syntax-highlighting
  fast-syntax-highlighting
  zsh-autocomplete
  history
  extract
  colorize
)

source \$ZSH/oh-my-zsh.sh

# Preferred editor
export EDITOR="emacs"
EOF

# Set zsh as default shell
chsh -s $(which zsh) root

# Add SSH public keys
mkdir -p /root/.ssh
chmod 700 /root/.ssh
cat > /root/.ssh/authorized_keys << 'EOF'
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICwonSxwmTMOAH2564xFmezf6cGnmzvKwyiEDdxUzcFO dirkekelund@Mac.fritz.box
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCs6qVp41WYGvwe702HiUyMIAUbuUHUqPiNxCiDOYXDFGfCIXnllgkWt8FPgCP3SBl6CeM2e/RQ3q/vNHRJyoDpsFWpHHZoIDC57/BIy/8LPt4/jhcGdKR9MownMZ1+cOJdUDfoIHTx3ngESf8SHxKa2uR2RwlLpvjQ1sJfMbBYErWfo0uq2fXeHi5G8LWcCcqvgIUaBvPA6TVcGaurLYxRS+xyp8Vn+XxGnWdJu2FV61uniRRvV0AnS8ddFBfjOfToA2YcSSG1joyjRRA4FGEeFydet6whjTmjVmOraKosH+BAYPK8JotPrTGBVAEFLtyICN1d9QuIsyO54qexZg/q+SGZsnzCF/WK2YlK4yxkZQU/XHQBUFd6RBg41EqJGdUbCA5FFyY33UZR3ZlsB7nkj7kXO7oc6f+0XK3w1Q6M9Agt8VsNJ3Wv+mWAfUGD+x3F+vbqPWEvFxVI/kkS/4+kQVVbLRz2J8/UeW59sNhSNnVdpk+pVHaS9VKT/ULo8gf6RLrdz+t5eLqkdpd0e0vLCamr18S3P+If6diRC33G92X2m48XkAIfgrpXFMKpcpnz/dQwrA9ZAyg4Xdoe3d+1BaUfb6ybIXqsbzTAPrg4tU5NFrP34okENuPh+Myyvqq/MDWbZlVWKgVcsvzA+CCwkX8ni+XXYTCz3b4n8R9yDw== dirkekelund@Mac.fritz.box
EOF
chmod 600 /root/.ssh/authorized_keys

echo "----------------------------------------"
echo "[`date`] Setup complete! Reboot recommended."
echo "----------------------------------------"
