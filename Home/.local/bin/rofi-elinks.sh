#!/bin/bash

INPUT=""

while true; do
    if [ -z "$INPUT" ]; then
        # Primeira tela: pede o termo para pesquisa
        # Format 'i s' -> "-1 texto" se for novo texto
        SAIDA=$(rofi -dmenu -theme ~/.config/rofi/elinks.rasi -theme-str 'listview { lines: 0; } window { height: 75px; } mainbox { children: [ "inputbar" ]; }' -p "Pesquisar:" -format 'i s' < /dev/null)
        RET=$?
    else
        # Busca sugestões da API do DuckDuckGo usando GET (-G)
        # Usamos grep e sed para extrair as frases (não requer jq)
        SUGESTOES=$(curl -sL -G --data-urlencode "q=$INPUT" "https://duckduckgo.com/ac/" | grep -o '"phrase":"[^"]*' | sed 's/"phrase":"//')
        
        # Adiciona as opções de motores de busca no topo
        LISTA="-> DuckDuckGo: $INPUT\n-> Google: $INPUT\n-> Wikipédia: $INPUT"
        if [ -n "$SUGESTOES" ]; then
            LISTA="$LISTA\n$SUGESTOES"
        fi
        
        # Exibe as sugestões
        SAIDA=$(echo -e "$LISTA" | rofi -dmenu -theme ~/.config/rofi/elinks.rasi -p "Sugestões:" -format 'i s')
        RET=$?
    fi
    
    # Se cancelou com Esc (RET = 1) ou se a saída for vazia
    if [ $RET -eq 1 ] || [ -z "$SAIDA" ]; then
        exit 0
    fi
    
    # Extrai o índice e a seleção usando awk/cut
    # SAIDA é algo como "-1 novo texto" ou "0 -> DuckDuckGo: termo"
    INDEX=$(echo "$SAIDA" | awk '{print $1}')
    SELECAO=$(echo "$SAIDA" | cut -d' ' -f2-)
    
    ENGINE="ddg" # Motor de busca padrão para sugestões
    
    # Verifica se escolheu uma das opções principais e limpa o prefixo
    if [[ "$SELECAO" == "-> DuckDuckGo: "* ]]; then
        SELECAO="${SELECAO#-> DuckDuckGo: }"
        ENGINE="ddg"
    elif [[ "$SELECAO" == "-> Google: "* ]]; then
        SELECAO="${SELECAO#-> Google: }"
        ENGINE="g"
    elif [[ "$SELECAO" == "-> Wikipédia: "* ]]; then
        SELECAO="${SELECAO#-> Wikipédia: }"
        ENGINE="w"
    fi
    
    if [ "$INDEX" = "-1" ]; then
        # Usuário digitou um texto novo em vez de selecionar.
        # Atualizamos o INPUT para buscar sugestões para esse novo texto.
        INPUT="$SELECAO"
        continue
    else
        # Usuário selecionou uma opção da lista (seja a original ou uma sugestão)
        # Podemos encerrar o loop e pesquisar!
        break
    fi
done

# Realiza a pesquisa pelo w3m
# O 'sleep 0.1' garante que o w3m só inicie após o Sway terminar de redimensionar a janela flutuante
# Se começar com http:// ou https://, ou www., abre o site diretamente
if [[ "$SELECAO" == http://* ]] || [[ "$SELECAO" == https://* ]] || [[ "$SELECAO" == www.* ]]; then
    foot -a flutuante-elinks bash -c 'sleep 0.1 && exec w3m "$0"' "$SELECAO"
else
    # Codifica espaços para URLs (+ é aceito por todos os motores)
    ENCODED="${SELECAO// /+}"
    
    # Define a URL de acordo com o motor escolhido
    if [ "$ENGINE" = "ddg" ]; then
        URL="https://lite.duckduckgo.com/lite/?q=$ENCODED&kl=br-pt"
    elif [ "$ENGINE" = "g" ]; then
        # Google: Substituído pelo Brave Search devido ao bloqueio estrito do Google contra terminais
        URL="https://search.brave.com/search?q=$ENCODED"
    elif [ "$ENGINE" = "w" ]; then
        URL="https://pt.wikipedia.org/wiki/Special:Search?search=$ENCODED"
    fi
    
    foot -a flutuante-elinks bash -c 'sleep 0.1 && exec w3m "$0"' "$URL"
fi

