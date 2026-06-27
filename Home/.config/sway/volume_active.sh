#!/bin/bash
# Obtém o PID da janela focada no Sway
MAIN_PID=$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true) | .pid' | head -n 1)

if [ -z "$MAIN_PID" ] || [ "$MAIN_PID" == "null" ]; then
    exit 0
fi

# Função para encontrar todos os PIDs filhos recursivamente
get_all_pids() {
    local pids="$1"
    local children=$(pgrep -P "$pids" -d, 2>/dev/null)
    echo "$pids"
    if [ -n "$children" ]; then
        get_all_pids "$children"
    fi
}

# Extrai todos os processos filhos desta janela (ex: a janela é o terminal, mas o player é o ncspot dentro dele)
PIDS=$(get_all_pids "$MAIN_PID" | tr '\n' ',' | sed 's/,$//')

if [ -z "$PIDS" ]; then
    exit 0
fi

# Busca no PipeWire/PulseAudio os IDs dos nós de áudio que pertencem a qualquer um desses processos
NODE_IDS=$(pw-dump | jq -r --argjson pids "[$PIDS]" '
  .[] | 
  select(.info.props."media.class" == "Stream/Output/Audio" and (.info.props."application.process.id" as $pid | $pids | index($pid))) | 
  .id
')

# Altera o volume de todos os nós de áudio encontrados
for ID in $NODE_IDS; do
    if [ -n "$ID" ]; then
        wpctl set-volume "$ID" "$1"
    fi
done
