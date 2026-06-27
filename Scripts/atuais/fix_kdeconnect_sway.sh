#!/bin/bash
set -e

echo "=> Instalando dependências..."
sudo apt update
sudo apt install -y cmake g++ pkg-config qt6-base-dev qt6-base-private-dev libwayland-dev libxkbcommon-dev libei-dev libeis-dev libwayland-client0 wayland-protocols xdg-desktop-portal

echo "=> Baixando o código-fonte (hypr-kdeconnect-fix)..."
cd /tmp
rm -rf hypr-kdeconnect-fix
git clone https://github.com/gfhdhytghd/hypr-kdeconnect-fix.git
cd hypr-kdeconnect-fix
sed -i 's/libeis-1.0>=1.4/libeis-1.0>=1.3/g' CMakeLists.txt
sed -i 's/if (normalized.isEmpty() || normalized.size() > kMaxAppIdLength)/if (normalized.size() > kMaxAppIdLength) return false; if (normalized.isEmpty()) return true; \/\//g' src/security_policy.hpp

echo "=> Compilando e instalando em ~/.local ..."
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$HOME/.local" -DHKCF_PORTAL_USE_IN="sway"
cmake --build build -j"$(nproc)"
cmake --install build

echo "=> Configurando o xdg-desktop-portal para o Sway..."
mkdir -p ~/.config/xdg-desktop-portal
PORTAL_CONF="$HOME/.config/xdg-desktop-portal/portals.conf"

if [ ! -f "$PORTAL_CONF" ]; then
    echo "[preferred]" > "$PORTAL_CONF"
fi

if ! grep -q "default=gtk" "$PORTAL_CONF"; then
    sed -i '/\[preferred\]/a default=gtk' "$PORTAL_CONF"
fi

if ! grep -q "org.freedesktop.impl.portal.RemoteDesktop=hypr-kdeconnect" "$PORTAL_CONF"; then
    echo "org.freedesktop.impl.portal.RemoteDesktop=hypr-kdeconnect" >> "$PORTAL_CONF"
fi

echo "=> Garantindo que o xdg-desktop-portal leia a pasta ~/.local/share..."
mkdir -p ~/.config/environment.d
if ! grep -q 'XDG_DATA_DIRS.*\.local/share' ~/.config/environment.d/xdg.conf 2>/dev/null; then
    echo 'XDG_DATA_DIRS="$HOME/.local/share:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"' >> ~/.config/environment.d/xdg.conf
fi
systemctl --user set-environment XDG_DATA_DIRS="$HOME/.local/share:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"

echo "=> Reiniciando serviços relacionados..."
systemctl --user daemon-reload
systemctl --user restart hypr-kdeconnect-portal
systemctl --user restart xdg-desktop-portal
killall kdeconnectd || true

echo "=========================================================="
echo "Instalação concluída com sucesso!"
echo "Agora, tente usar o 'Introdução de dados remota' do KDE Connect pelo seu celular."
echo "Certifique-se de que o diretório ~/.local/bin está no seu PATH."
echo "=========================================================="
