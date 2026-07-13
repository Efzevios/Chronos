#!/bin/bash

# Este script instala todas as dependências, baixa o código-fonte,
# compila e instala o wl-kbptr com suporte a OpenCV no Debian 13 / Sway.

set -e

echo "=========================================="
echo "    Instalador Automático do wl-kbptr     "
echo "=========================================="
echo ""

echo "-> Atualizando repositórios e instalando dependências necessárias..."
# Instala compiladores, bibliotecas do Wayland, Cairo, e o OpenCV (para o modo Hint/Flutuante)
sudo apt-get update
sudo apt-get install -y build-essential meson ninja-build git \
    libwayland-dev wayland-protocols libxkbcommon-dev libcairo2-dev \
    libopencv-dev libpixman-1-dev g++ jq

echo "-> Criando ambiente de compilação temporário..."
BUILD_DIR=$(mktemp -d)
cd "$BUILD_DIR"

echo "-> Baixando a versão mais recente do código-fonte (wl-kbptr)..."
git clone https://github.com/moverest/wl-kbptr.git
cd wl-kbptr

echo "-> Configurando a compilação (Com OpenCV ativado)..."
# A flag -Dopencv=enabled é o que permite o modo flutuante enxergar a tela
meson setup build --buildtype=release -Dopencv=enabled

echo "-> Compilando o programa..."
meson compile -C build

echo "-> Instalando no sistema..."
sudo meson install -C build

echo "-> Limpando arquivos de instalação..."
cd ~
rm -rf "$BUILD_DIR"

echo ""
echo "=========================================="
echo " Instalação do wl-kbptr Concluída! "
echo "=========================================="
echo "O programa foi compilado com sucesso e os comandos 'wl-kbptr' já estão disponíveis."
echo "Certifique-se de recarregar o Sway (swaymsg reload) para que seus atalhos funcionem."
