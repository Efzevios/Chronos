#!/bin/bash

# Interrompe o script em caso de erro
set -e

echo "--- Iniciando Instalação do OpenTabletDriver (Debian 13) ---"

# 1. Adicionando o repositório da Microsoft para o .NET Runtime
echo "[1/5] Configurando repositório da Microsoft para dependências..."
wget https://packages.microsoft.com/config/debian/13/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt update

# 2. Baixando a versão estável mais recente do OTD dinamicamente
echo "[2/5] Buscando e baixando o pacote .deb mais recente do GitHub..."
URL_LATEST_DEB=$(curl -s https://api.github.com/repos/OpenTabletDriver/OpenTabletDriver/releases/latest | grep "browser_download_url.*\.deb" | cut -d '"' -f 4)

if [ -z "$URL_LATEST_DEB" ]; then
    echo "Erro: Não foi possível localizar o link de download na API do GitHub. Verifique sua conexão."
    exit 1
fi

echo "Baixando de: $URL_LATEST_DEB"
wget "$URL_LATEST_DEB" -O opentabletdriver.deb

# 3. Instalando o driver e resolvendo dependências automaticamente
echo "[3/5] Instalando o pacote e baixando dependências (.NET)..."
sudo apt install ./opentabletdriver.deb -y

# 4. Removendo drivers nativos que causam conflito
echo "[4/5] Desativando drivers nativos (Wacom/UCLogic)..."
sudo rmmod wacom hid_uclogic || echo "Aviso: Módulos já removidos ou não encontrados."
sudo update-initramfs -u

# 5. Habilitando o serviço para o usuário
echo "[5/5] Ativando o serviço do OpenTabletDriver..."
systemctl --user enable opentabletdriver.service --now

echo "--------------------------------------------------------"
echo "Instalação concluída com sucesso!"
echo "Você pode abrir o 'OpenTabletDriver' pelo menu do sistema."
echo "--------------------------------------------------------"
