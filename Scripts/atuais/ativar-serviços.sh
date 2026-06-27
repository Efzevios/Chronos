#!/bin/bash

echo "Ativando Syncthing (Modo Usuário)..."
systemctl --user enable --now syncthing.service

echo "Ativando OpenTabletDriver (Modo Usuário)..."
systemctl --user enable --now opentabletdriver.service

echo "Verificando o status dos serviços:"
systemctl --user status syncthing.service --no-pager | grep "Active:"
systemctl --user status opentabletdriver.service --no-pager | grep "Active:"

echo "Concluído!"
