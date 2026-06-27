#!/bin/bash

set -e # Sai do script caso ocorra algum erro

echo "==> Atualizando repositórios e instalando pacotes necessários (wl-clipboard, cliphist, wofi)..."
sudo apt update
sudo apt install -y wl-clipboard cliphist wofi

CONFIG_DIR="$HOME/.config/sway"
CONFIG_FILE="$CONFIG_DIR/config"

echo "==> Verificando arquivo de configuração do SwayFX..."

# Cria o diretório de configuração do sway se não existir
if [ ! -d "$CONFIG_DIR" ]; then
    echo "Diretório $CONFIG_DIR não encontrado. Criando..."
    mkdir -p "$CONFIG_DIR"
fi

# Copia o config padrão do sistema se o usuário ainda não tiver um
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Arquivo de configuração não encontrado em $CONFIG_FILE."
    echo "Copiando arquivo de configuração padrão do sistema..."
    if [ -f "/etc/sway/config" ]; then
        cp /etc/sway/config "$CONFIG_FILE"
    else
        echo "Aviso: /etc/sway/config não encontrado. Criando um arquivo em branco..."
        touch "$CONFIG_FILE"
    fi
fi

echo "==> Configurando inicialização e atalho no SwayFX..."

# Verifica se o cliphist já está configurado no arquivo para evitar entradas duplicadas
if grep -q "cliphist" "$CONFIG_FILE"; then
    echo "A configuração do cliphist já existe no arquivo $CONFIG_FILE. Pulando essa etapa para evitar duplicação."
else
    # Adiciona as configurações ao final do arquivo
    cat <<EOT >> "$CONFIG_FILE"

### Configuração do Cliphist (Área de Transferência)
exec wl-paste --type text --watch cliphist store
exec wl-paste --type image --watch cliphist store
bindsym \$mod+c exec cliphist list | wofi --dmenu --prompt "Área de Transferência" | cliphist decode | wl-copy
EOT
    echo "Configuração adicionada com sucesso!"
fi

echo "==> Tentando recarregar as configurações do SwayFX..."
# Usa o swaymsg para recarregar as configurações instantaneamente, se o sway estiver rodando
if command -v swaymsg &> /dev/null; then
    # O '|| true' previne que o script aborte no 'set -e' caso o swaymsg falhe (ex: rodando de um TTY limpo)
    swaymsg reload 2>/dev/null && echo "SwayFX recarregado com sucesso!" || echo "Aviso: Não foi possível usar o 'swaymsg'. Recarregue o SwayFX manualmente (Mod+Shift+c)."
else
    echo "Comando 'swaymsg' não encontrado. Recarregue o SwayFX manualmente (Mod+Shift+c)."
fi

echo "==> Tudo pronto! O cliphist foi instalado e configurado."
echo "==> Aperte Mod+C no seu SwayFX para testar."
