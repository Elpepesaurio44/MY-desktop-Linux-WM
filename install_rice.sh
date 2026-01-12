#!/bin/bash

# --- 1. Detección del Gestor de Paquetes ---
if [ -f /etc/debian_version ]; then
    OS="debian"
    INSTALL="sudo apt install -y"
    PKGS="tint2 pipes-sh tty-clock cmatrix pcmanfm lxappearance feh conky alacritty rofi picom fonts-jetbrains-mono zsh curl git lsd"
elif [ -f /etc/arch-release ]; then
    OS="arch"
    INSTALL="sudo pacman -S --noconfirm"
    PKGS="tint2 pipes.sh tty-clock cmatrix pcmanfm lxappearance feh conky alacritty rofi picom ttf-jetbrains-mono zsh curl git lsd"
elif [ -f /etc/fedora-release ]; then
    OS="fedora"
    INSTALL="sudo dnf install -y"
    PKGS="tint2 pipes.sh tty-clock cmatrix pcmanfm lxappearance feh conky alacritty rofi picom jetbrains-mono-fonts zsh curl git lsd"
elif [ -f /etc/alpine-release ]; then
    OS="alpine"
    INSTALL="sudo apk add"
    PKGS="tint2 pipes.sh tty-clock cmatrix pcmanfm lxappearance feh conky alacritty rofi picom font-jetbrains-mono zsh curl git lsd"
else
    echo "Distribución no soportada automáticamente. Instala los paquetes manualmente."
    exit 1
fi

echo "--- Instalando dependencias para $OS ---"
$INSTALL $PKGS

# --- 2. Instalación de Oh My Zsh (No interactivo) ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "--- Instalando Oh My Zsh ---"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# --- 3. Plugins y Temas de ZSH ---
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

echo "--- Clonando temas y plugins ---"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k 2>/dev/null
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions 2>/dev/null
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting 2>/dev/null

# --- 4. Copia de Archivos de Configuración (Dotfiles) ---
# Asumimos que el script se ejecuta desde la carpeta i3wm-config/
DOTS_DIR="./home"

if [ -d "$DOTS_DIR" ]; then
    echo "--- Copiando archivos de configuración ---"
    
    # Copiar .config (i3, alacritty, tint2, etc)
    cp -rv $DOTS_DIR/.config/* $HOME/.config/ 2>/dev/null
    
    # Copiar .local (scripts o binarios)
    cp -rv $DOTS_DIR/.local/* $HOME/.local/ 2>/dev/null
    
    # Copiar archivos sueltos en el HOME
    cp -v $DOTS_DIR/.zshrc $HOME/
    cp -v $DOTS_DIR/Logo.png $HOME/
    
    # Copiar temas
    mkdir -p $HOME/.themes
    cp -rv $DOTS_DIR/.themes/* $HOME/.themes/ 2>/dev/null
else
    echo "Error: No se encontró la carpeta 'home' con los archivos."
fi

echo "--- Proceso completado. Cambiando shell a ZSH ---"
sudo chsh -s $(which zsh) $USER

echo "Instalación terminada. Reinicia la sesión para ver los cambios."
