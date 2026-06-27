#!/bin/bash
set -e

echo "==> Atualizando repositórios e instalando dependências necessárias..."
# Instalamos as bibliotecas do Wayland e também as dependências padrão do Rofi
sudo apt-get update
sudo apt-get install -y git build-essential meson ninja-build pkg-config \
    bison flex libwayland-dev wayland-protocols libxkbcommon-dev \
    libpango1.0-dev libcairo2-dev libglib2.0-dev libgdk-pixbuf-2.0-dev \
    libstartup-notification0-dev libxcb-randr0-dev libxcb-xinerama0-dev \
    libxcb-cursor-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xrm-dev \
    libx11-xcb-dev libmpdclient-dev libjpeg-dev check \
    libxcb-xkb-dev libxkbcommon-x11-dev libxcb-keysyms1-dev libasound2-dev

# Criar um diretório temporário
BUILD_DIR="/tmp/rofi-wayland-build"
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

echo "==> Clonando a versão mais recente do Rofi (fork Wayland do lbonn)..."
# O uso de --depth=1 e branches puras garante sempre o código (latest commit) mais recente da origin
git clone --depth=1 https://github.com/lbonn/rofi.git
cd rofi

echo "==> Removendo o pacote Rofi do APT para evitar conflitos de versão..."
sudo apt-get remove -y rofi || true

echo "==> Configurando o ambiente de compilação (Meson)..."
# Inicia a configuração do projeto (ele vai gerar os scripts Ninja na pasta build)
meson setup build

echo "==> Compilando o projeto e instalando globalmente..."
ninja -C build
sudo ninja -C build install

echo "==> Limpando o sistema..."
cd ~
rm -rf "$BUILD_DIR"

echo ""
echo "=========================================================="
echo "✅ Concluído! rofi-wayland compilado e instalado com sucesso."
echo "=========================================================="
# O comando abaixo deve agora retornar a versão com o sufixo "+wayland"
rofi -version
