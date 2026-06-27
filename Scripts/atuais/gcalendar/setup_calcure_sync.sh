#!/bin/bash
set -e

echo "=== Removendo instalações e configurações antigas ==="
pipx uninstall calcure || true
sudo apt-get remove --purge vdirsyncer -y || true

rm -rf ~/.config/vdirsyncer
rm -rf ~/.local/share/vdirsyncer
rm -rf ~/.config/calcure
rm -rf ~/.local/share/calcure
rm -rf ~/.local/share/calendars

echo "=== Instalando dependências ==="
sudo apt-get update && sudo apt-get install vdirsyncer python3-aiohttp-oauthlib -y
pipx install calcure

echo "=== Configurando o Vdirsyncer ==="
mkdir -p ~/.config/vdirsyncer ~/.local/share/vdirsyncer ~/.local/share/calendars

# Caminho para o seu arquivo JSON de credenciais
JSON_FILE="caminho/para/seu/arquivo-client-secret.json"

if [ ! -f "$JSON_FILE" ]; then
    echo "ERRO: Arquivo JSON não encontrado em $JSON_FILE"
    exit 1
fi

# Extraindo dados do JSON com Python (já que é nativo do sistema)
CLIENT_ID=$(python3 -c "import json; print(json.load(open('$JSON_FILE'))['installed']['client_id'])")
CLIENT_SECRET=$(python3 -c "import json; print(json.load(open('$JSON_FILE'))['installed']['client_secret'])")

cat <<EOF > ~/.config/vdirsyncer/config
[general]
status_path = "~/.local/share/vdirsyncer/status/"

[pair meu_calendario_google]
a = "google_remoto"
b = "local"
collections = ["from a", "from b"]
metadata = ["color"]

[storage google_remoto]
type = "google_calendar"
client_id = "$CLIENT_ID"
client_secret = "$CLIENT_SECRET"
token_file = "~/.local/share/vdirsyncer/google_token"

[storage local]
type = "singlefile"
path = "~/.local/share/calendars/%s.ics"
EOF

echo "=== Descobrindo Calendários e Autorizando ==="
echo "Um link do Google será exibido abaixo. Por favor, clique nele, faça o login e autorize."
echo "Após autorizar, o script continuará automaticamente."
yes | vdirsyncer discover

echo "=== Sincronizando Eventos ==="
vdirsyncer sync

echo "=== Configurando o Calcure ==="
mkdir -p ~/.config/calcure

# Gerando a configuração do calcure apenas com as opções base
# E listando dinamicamente os .ics que o vdirsyncer gerou
ICS_FILES=$(ls -1 ~/.local/share/calendars/*.ics | tr '\n' ',' | sed 's/,$//')

cat <<EOF > ~/.config/calcure/config.ini
[Parameters]
folder_with_datafiles = ~/.config/calcure
ics_event_files = $ICS_FILES
language = pt
EOF

echo "=== Tudo pronto! ==="
echo "Basta digitar 'calcure' para acessar seus calendários."
