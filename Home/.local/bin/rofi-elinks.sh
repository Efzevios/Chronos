#!/bin/bash

# Define the search options
OPCOES="ddg - DuckDuckGo\nw - Wikipedia\nwd - Wiktionary\ng - Google\nyt - YouTube\ndd - Dicio.com.br\nm - Michaelis"

# Show Rofi menu to choose engine
ESCOLHA=$(echo -e "$OPCOES" | rofi -dmenu -theme ~/.config/rofi/elinks.rasi -i -p "Busca rápida:")

# Extract the prefix
PREFIXO=$(echo "$ESCOLHA" | awk '{print $1}')

if [ -z "$PREFIXO" ]; then
    exit 0
fi

# Request search term
TERMO=$(rofi -dmenu -theme ~/.config/rofi/elinks.rasi -p "Pesquisar no $PREFIXO:")

if [ -z "$TERMO" ]; then
    exit 0
fi

# Run foot terminal as floating class with elinks
foot -a flutuante-elinks elinks "$PREFIXO $TERMO"
