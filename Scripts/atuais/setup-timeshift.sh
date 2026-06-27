#!/bin/bash

# Cores para saída no terminal
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # Sem cor

echo -e "${BLUE}==> Iniciando configuração do Timeshift para Sway/Wayland...${NC}"

# 1. Criar pastas necessárias
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share/applications"

# 2. Criar o script wrapper
WRAPPER_PATH="$HOME/.local/bin/timeshift-wayland"
echo -e "${BLUE}==> Criando script wrapper em: $WRAPPER_PATH${NC}"

cat << EOF > "$WRAPPER_PATH"
#!/bin/bash
# Script gerado automaticamente para rodar Timeshift via Foot no Wayland
foot -e bash -c "pkexec env DISPLAY=\$DISPLAY XAUTHORITY=\$XAUTHORITY WAYLAND_DISPLAY=\$WAYLAND_DISPLAY XDG_RUNTIME_DIR=\$XDG_RUNTIME_DIR setsid -f timeshift-gtk"
EOF

chmod +x "$WRAPPER_PATH"

# 3. Configurar o arquivo .desktop
echo -e "${BLUE}==> Configurando atalho .desktop local...${NC}"
ORIGINAL_DESKTOP="/usr/share/applications/timeshift-gtk.desktop"
LOCAL_DESKTOP="$HOME/.local/share/applications/timeshift-gtk.desktop"

if [ -f "$ORIGINAL_DESKTOP" ]; then
    cp "$ORIGINAL_DESKTOP" "$LOCAL_DESKTOP"
    # Substitui a linha Exec pelo caminho do nosso script
    sed -i "s|^Exec=.*|Exec=$WRAPPER_PATH|" "$LOCAL_DESKTOP"
    echo -e "${GREEN}[OK] Atalho configurado.${NC}"
else
    echo -e "\033[0;31m[ERRO] Arquivo original do Timeshift não encontrado em /usr/share/applications/.${NC}"
fi

# 4. Tentar ativar o serviço de cron (requer sudo)
echo -e "${BLUE}==> Verificando serviços de agendamento (Cron)...${NC}"
if [ -f /etc/debian_version ]; then
    echo "Detectado sistema baseado em Debian. Ativando 'cron'..."
    sudo apt update && sudo apt install -y cron
    sudo systemctl enable --now cron
elif [ -f /etc/fedora-release ]; then
    echo "Detectado sistema baseado em Fedora. Ativando 'cronie'..."
    sudo dnf install -y cronie
    sudo systemctl enable --now crond
else
    echo "Distribuição não identificada. Por favor, garanta que o serviço 'cron' ou 'cronie' esteja ativo manualmente."
fi

# 5. Limpar cache do Wofi
echo -e "${BLUE}==> Limpando cache do Wofi...${NC}"
rm -f "$HOME/.cache/wofi-"* 2>/dev/null

echo -e "${GREEN}==> Configuração concluída!${NC}"
echo -e "Agora você pode abrir o Timeshift pelo Wofi normalmente."
