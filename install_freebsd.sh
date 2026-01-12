#!/bin/sh

# --- 1. Instalación de Paquetes ---
# Nota: En FreeBSD, algunos nombres cambian (ej. pipes.sh es pipes)
echo "--- Instalando dependencias en FreeBSD ---"
sudo pkg install -y \
    tint2 \
    pipes.sh \
    tty-clock \
    cmatrix \
    pcmanfm \
    lxappearance \
    feh \
    conky \
    alacritty \
    rofi \
    picom \
    jetbrains-mono \
    zsh \
    curl \
    git \
    lsd \
    bash

# --- 2. Instalación de Oh My Zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "--- Instalando Oh My Zsh ---"
    # Usamos env ZSH= para evitar que el instalador intente entrar a zsh inmediatamente
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# --- 3. Plugins y Temas de ZSH ---
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

echo "--- Clonando Powerlevel10k y Plugins ---"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k 2>/dev/null
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions 2>/dev/null
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting 2>/dev/null

# --- 4. Copia de Archivos (Dotfiles) ---
# Se asume que ejecutas el script desde i3wm-config/
DOTS_DIR="./home"

if [ -d "$DOTS_DIR" ]; then
    echo "--- Copiando archivos de configuración a $HOME ---"
    
    # Crear carpetas necesarias
    mkdir -p $HOME/.config
    mkdir -p $HOME/.local
    mkdir -p $HOME/.themes

    # Copiar contenidos
    cp -Rv $DOTS_DIR/.config/ $HOME/.config/
    cp -Rv $DOTS_DIR/.local/ $HOME/.local/
    cp -v $DOTS_DIR/.zshrc $HOME/
    cp -v $DOTS_DIR/Logo.png $HOME/
    cp -Rv $DOTS_DIR/.themes/ $HOME/.themes/
else
    echo "Error: No se encontró la carpeta 'home' dentro del directorio actual."
fi

# --- 5. Cambio de Shell ---
echo "--- Cambiando Shell a ZSH ---"
# En FreeBSD zsh está en /usr/local/bin/zsh
sudo chsh -s /usr/local/bin/zsh $USER

echo "-------------------------------------------------------"
echo "Instalación completada con éxito."
echo "IMPORTANTE: En FreeBSD, asegúrate de tener activado"
echo "procfs en /etc/fstab para que algunas herramientas funcionen."
echo "-------------------------------------------------------"
