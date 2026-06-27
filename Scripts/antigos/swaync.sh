#!/usr/bin/env bash
# Script para instalar o Sway Notification Center (SwayNC) no Debian

set -e

echo "================================================="
echo " Instalador do Sway Notification Center (SwayNC) "
echo "================================================="
echo ""

echo "[1/2] Atualizando as listas de pacotes (requer senha de sudo)..."
sudo apt-get update

echo ""
echo "[2/2] Instalando o sway-notification-center e dependências via APT..."
sudo apt-get install -y sway-notification-center

echo ""
echo "================================================="
echo " Instalação concluída com sucesso!               "
echo "================================================="
echo "Para testar, você pode rodar o comando abaixo no terminal:"
echo "  swaync &"
echo "E depois enviar uma notificação de teste:"
echo "  notify-send 'SwayNC' 'Instalação funcionou perfeitamente!'"
