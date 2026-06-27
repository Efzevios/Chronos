#!/bin/bash

# Script de configuração de Áudio para o Sway (Debian/Ubuntu)
# Resolve o problema de travamentos e volume baixo configurando o WirePlumber
# para usar soft-mixer e ignorar o timeout de suspensão do ALSA.

set -e

echo "Instalando dependências do PipeWire e WirePlumber..."
# Dependências principais de som para o Wayland/Sway usando Pipewire
sudo apt update
sudo apt install -y jq pipewire pipewire-audio pipewire-alsa pipewire-pulse pipewire-jack wireplumber pavucontrol

echo "Habilitando os serviços do PipeWire e WirePlumber para o usuário atual..."
systemctl --user enable --now pipewire pipewire-pulse wireplumber

echo "Criando diretório de configuração personalizada do WirePlumber..."
mkdir -p "$HOME/.config/wireplumber/wireplumber.conf.d/"

CONF_FILE="$HOME/.config/wireplumber/wireplumber.conf.d/51-alsa-suspend.conf"

echo "Aplicando as regras anti-suspensão e de soft-mixer no ALSA..."
cat << 'EOF' > "$CONF_FILE"
monitor.alsa.rules = [
  {
    matches = [
      { node.name = "~alsa_input.*" },
      { node.name = "~alsa_output.*" }
    ]
    actions = {
      update-props = {
        session.suspend-timeout-seconds = 0
        api.alsa.soft-mixer = true
      }
    }
  }
]
EOF

echo "Reiniciando os serviços de áudio para aplicar as mudanças..."
systemctl --user restart wireplumber pipewire pipewire-pulse

echo ""
echo "=========================================================="
echo "✅ Configuração concluída e aplicada com sucesso!"
echo "O volume do seu sistema Sway agora não sofrerá mais quedas"
echo "ao pausar mídia, e o volume máximo será respeitado."
echo "=========================================================="
