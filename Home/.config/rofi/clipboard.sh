#!/bin/bash

# Diretório base
CONFIG_DIR="/home/efzevios/.config/rofi"

# Define um caractere separador invísivel de forma robusta
SEP=$(printf '\x1e')

# Lista o cliphist e limita a 200 itens
# O rofi retorna o índice (-format i) do item selecionado (baseado em 0)
INDEX=$(cliphist list | head -n 200 | awk -v sep="$SEP" '{
  id=$1
  $1=""
  content=substr($0, 2)
  raw_content=content
  
  gsub(/&/, "&amp;", content)
  gsub(/</, "&lt;", content)
  gsub(/>/, "&gt;", content)
  
  if (length(content) > 75) {
     content = substr(content, 1, 75) "..."
  }
  
  type="Texto"
  icon="T"
  if (raw_content ~ /^\[\[ binary data/) {
    type="Imagem"
    content="[Conteúdo Binário]"
    icon=""
  } else if (length(raw_content) > 100) {
    type="Longo Texto"
    icon="󰍜"
  } else {
    type="Texto"
    icon="󰆏"
  }

  # Construímos a string final usando o caractere separador
  printf "<span foreground=\"#CCCCCC\"><b>[ %s ]</b></span>  <span foreground=\"#A0A0A0\">%s  %s</span>\n<span foreground=\"#E2E2E2\">%s</span>%s", NR, icon, type, content, sep
}' | rofi -dmenu \
    -no-config \
    -eh 2 \
    -sep "$SEP" \
    -markup-rows \
    -theme "$CONFIG_DIR/clipboard.rasi" \
    -p " " \
    -mesg "󰆏  Histórico da Área de Transferência" \
    -format i)

# Se um índice válido for retornado, extrai a linha original correspondente do cliphist
if [ -n "$INDEX" ] && [ "$INDEX" -ge 0 ]; then
    LINE_NUM=$((INDEX + 1))
    cliphist list | sed -n "${LINE_NUM}p" | cliphist decode | wl-copy
fi
