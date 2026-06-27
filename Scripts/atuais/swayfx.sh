#!/bin/bash

# Interrompe o script caso qualquer comando retorne erro
set -e

echo "=== Atualizando repositórios e instalando dependências ==="
sudo apt update

# Instalando a primeira lista de dependências (com a flag -y para não pedir confirmação)
sudo apt install -y \
  meson ninja-build cmake pkg-config scdoc git \
  libwayland-dev wayland-protocols libdrm-dev libgbm-dev libinput-dev \
  libxkbcommon-dev libudev-dev libpixman-1-dev libseat-dev \
  libdisplay-info-dev libliftoff-dev hwdata \
  libegl-dev libgles-dev libvulkan-dev glslang-tools \
  xwayland libxcb1-dev libxcb-composite0-dev libxcb-dri3-dev libxcb-icccm4-dev \
  libxcb-present-dev libxcb-render0-dev libxcb-res0-dev libxcb-util0-dev \
  libxcb-xfixes0-dev libxcb-xinput-dev \
  libjson-c-dev libpcre2-dev libcairo2-dev libpango1.0-dev libgdk-pixbuf-2.0-dev libevdev-dev

# Instalando a segunda lista de dependências complementares
sudo apt install -y \
  meson pkg-config cmake git scdoc \
  wayland-protocols libwayland-dev libpcre2-dev libjson-c-dev \
  libpango1.0-dev libcairo2-dev libgdk-pixbuf-2.0-dev \
  libdrm-dev libgbm-dev libinput-dev libseat-dev libxkbcommon-dev \
  libxcb-dri3-dev libxcb-present-dev libxcb-res0-dev \
  libxcb-render-util0-dev libxcb-ewmh-dev libxcb-icccm4-dev \
  libliftoff-dev libdisplay-info-dev liblcms2-dev libpixman-1-dev \
  libgles2-mesa-dev

echo "=== Criando diretório de build ==="
mkdir -p ~/build
cd ~/build

echo "=== 1. Clonando SwayFX 0.5.3 (The Window Manager) ==="
git clone https://github.com/WillPower3309/swayfx.git
cd swayfx
git checkout 0.5.3

echo "=== 2. Configurando diretório de Subprojetos ==="
mkdir -p subprojects
cd subprojects

echo "=== 3. Clonando SceneFX 0.4.1 (The Rendering FX Library) ==="
git clone https://github.com/wlrfx/scenefx.git
cd scenefx
git checkout 0.4.1
cd ..

echo "=== 4. Clonando Wlroots 0.19.0 (The Wayland Compositor Backend) ==="
git clone https://gitlab.freedesktop.org/wlroots/wlroots.git
cd wlroots
git checkout 0.19.0

# Retornando para a raiz do código-fonte do SwayFX
cd ../..

echo "=== Configurando a build com Meson ==="
meson setup build/

echo "=== Compilando o projeto ==="
ninja -C build/

echo "=== Instalando no sistema ==="
sudo ninja -C build/ install
sudo ldconfig

echo "=== Instalação concluída! Verificando a versão: ==="
sway --version
