#!/bin/bash

# Este script instala as dependências necessárias para o seletor de cores nativo no SwayFX

echo "=========================================================="
echo "Instalando dependências para o Color Picker (Wayland/Sway)"
echo "=========================================================="
echo ""

echo "[1/2] Atualizando os repositórios (requer senha de root se não for root)..."
sudo apt update

echo ""
echo "[2/2] Instalando grim, slurp, imagemagick e wl-clipboard..."
sudo apt install -y grim slurp imagemagick wl-clipboard

echo ""
echo "=========================================================="
echo "Instalação concluída!"
echo "=========================================================="
echo ""
echo "Lembre-se de adicionar a seguinte linha ao seu arquivo ~/.config/sway/config:"
echo "bindsym \$mod+Shift+p exec grim -g \"\$(slurp -p)\" -t ppm - | convert - -format '%[pixel:p{0,0}]' txt:- | tail -n 1 | cut -d ' ' -f 4 | wl-copy"
echo ""
echo "Depois, reinicie o Sway ou use \$mod+Shift+c para recarregar as configurações."
