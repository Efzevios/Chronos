#!/bin/bash

echo "======================================================="
echo "   Configuração de Temas GTK e Qt (Graphite-Dark)      "
echo "======================================================="

# 0. Restaurar pasta de temas personalizados
echo -e "\n[*] Restaurando tema Graphite-Dark personalizado..."
mkdir -p ~/.themes
cp -r ~/Debian-Swayfx/Home/.themes/Graphite-Dark ~/.themes/ 2>/dev/null || echo "Tema já restaurado ou não encontrado no backup."

echo -e "\n[*] Restaurando temas e configs do Qt (Kvantum, qt5ct, qt6ct)..."
mkdir -p ~/.config/Kvantum ~/.config/qt5ct ~/.config/qt6ct
cp -r ~/Debian-Swayfx/Home/.config/Kvantum/* ~/.config/Kvantum/ 2>/dev/null
cp -r ~/Debian-Swayfx/Home/.config/qt5ct/* ~/.config/qt5ct/ 2>/dev/null
cp -r ~/Debian-Swayfx/Home/.config/qt6ct/* ~/.config/qt6ct/ 2>/dev/null
cp ~/Debian-Swayfx/Home/.config/kdeglobals ~/.config/ 2>/dev/null

# 1. Instalar dependências para que aplicativos Qt leiam o GTK
echo -e "\n[*] Instalando dependências (qt5ct, qt6ct, Kvantum)..."
sudo apt update
sudo apt install -y qt5ct qt6ct qt-style-kvantum qt-style-kvantum-themes qtwayland5 qml-module-org-kde-qqc2desktopstyle qml6-module-org-kde-desktop

# 2. Configurar Variáveis de Ambiente no .profile do usuário
echo -e "\n[*] Configurando variáveis de ambiente (~/.profile)..."
sed -i '/QT_QPA_PLATFORMTHEME/d' ~/.profile
sed -i '/QT_STYLE_OVERRIDE/d' ~/.profile
sed -i '/QT_QUICK_CONTROLS_STYLE/d' ~/.profile
sed -i '/GTK_THEME/d' ~/.profile
echo 'export QT_QPA_PLATFORMTHEME="qt5ct"' >> ~/.profile
# echo 'export QT_STYLE_OVERRIDE="kvantum"' >> ~/.profile # Removido pois quebra apps QML (ex: kdeconnect)
echo 'export QT_QUICK_CONTROLS_STYLE="org.kde.desktop"' >> ~/.profile
echo 'export GTK_THEME="Graphite-Dark"' >> ~/.profile

# 3. Forçar o tema via GSettings (necessário para alguns apps e portais)
echo -e "\n[*] Configurando GSettings (GNOME/GTK)..."
gsettings set org.gnome.desktop.interface gtk-theme 'Graphite-Dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# 4. Configurar permissões e variáveis para Flatpaks
echo -e "\n[*] Aplicando permissões de temas para todos os Flatpaks..."
# Acesso às pastas de temas
flatpak override --user --filesystem=~/.themes
flatpak override --user --filesystem=~/.local/share/themes
flatpak override --user --filesystem=~/.config/Kvantum:ro
flatpak override --user --filesystem=xdg-config/gtk-3.0:ro
flatpak override --user --filesystem=xdg-config/gtk-4.0:ro

# Variáveis globais do Flatpak (GTK e Qt)
flatpak override --user --env=GTK_THEME=Graphite-Dark
flatpak override --user --env=GTK_APPLICATION_PREFER_DARK_THEME=1
flatpak override --user --env=QT_QPA_PLATFORMTHEME=qt5ct
flatpak override --user --env=QT_QUICK_CONTROLS_STYLE=org.kde.desktop

echo -e "\n======================================================="
echo " Concluído! Para que todas as variáveis entrem em vigor,"
echo " saia da sua sessão do Sway e entre novamente (ou reinicie)."
echo "======================================================="
