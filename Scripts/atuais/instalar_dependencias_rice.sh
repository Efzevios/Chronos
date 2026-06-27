#!/bin/bash
echo "=========================================================="
echo "    Instalador de Dependências do Rice (Fontes & Rofi)    "
echo "=========================================================="

echo "[*] Instalando dependências e ferramentas de compilação via APT..."
sudo apt-get update
sudo apt-get install -y curl wget git meson ninja-build cmake pkg-config build-essential \
    wayland-protocols libwayland-dev libstartup-notification0-dev libxcb-randr0-dev \
    libxcb-xinerama0-dev libxcb-cursor-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xrm-dev \
    libx11-xcb-dev libmpdclient-dev libjpeg-dev check libxcb-xkb-dev libxkbcommon-x11-dev \
    libxcb-keysyms1-dev libasound2-dev flex bison libpango1.0-dev libglib2.0-dev libgdk-pixbuf2.0-dev unzip fontconfig

echo "[*] Baixando Fontes (Inter e Nerd Fonts)..."
mkdir -p ~/.local/share/fonts
mkdir -p /tmp/rice_fonts
cd /tmp/rice_fonts

echo " -> Baixando Inter..."
wget -q -O Inter.zip "https://github.com/rsms/inter/releases/download/v3.19/Inter-3.19.zip"
unzip -q -o Inter.zip -d ~/.local/share/fonts/Inter

echo " -> Baixando JetBrainsMono Nerd Font..."
wget -q -O JetBrainsMono.zip "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip"
unzip -q -o JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMono

echo " -> Baixando FiraCode Nerd Font..."
wget -q -O FiraCode.zip "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip"
unzip -q -o FiraCode.zip -d ~/.local/share/fonts/FiraCode

echo "[*] Atualizando cache de fontes do sistema..."
fc-cache -fv ~/.local/share/fonts/ >/dev/null

echo "[*] Baixando e compilando o Rofi-Wayland atualizado..."
cd /tmp
if [ -d "rofi" ]; then
    rm -rf rofi
fi
git clone https://github.com/lbonn/rofi.git
cd rofi
meson setup build
ninja -C build
sudo ninja -C build install

echo "[+] Limpando arquivos temporários..."
rm -rf /tmp/rice_fonts
rm -rf /tmp/rofi

echo "=========================================================="
echo "[+] Instalação concluída com sucesso!"
echo "As fontes (Inter e Nerd Fonts) e o rofi-wayland foram instalados."
echo "=========================================================="
