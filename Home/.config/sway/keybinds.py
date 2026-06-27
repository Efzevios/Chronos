#!/usr/bin/env python3
import json
import os

keybinds_file = os.path.expanduser('~/.config/sway/keybinds.txt')

try:
    with open(keybinds_file, 'r', encoding='utf-8') as f:
        text = f.read().strip()
except Exception:
    text = "Arquivo de atalhos não encontrado."

# O caractere  é um círculo sólido (pode ser trocado por ● ou  se preferir)
print(json.dumps({
    "text": "", 
    "tooltip": text
}))
