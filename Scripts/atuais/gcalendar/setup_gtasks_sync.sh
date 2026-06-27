#!/bin/bash
set -e

echo "=== Instalando o gtasks-terminal ==="
# Instalamos globalmente via pipx para não causar conflitos com o sistema
pipx install gtasks-cli

echo "=== Configurando credenciais ==="
# O gtasks espera que as credenciais estejam em ~/.gtasks/credentials.json
mkdir -p ~/.gtasks
rm -f ~/.gtasks/token.pickle

# Localizamos o JSON na pasta Downloads e copiamos
JSON_FILE="caminho/para/seu/arquivo-client-secret-gtasks.json"

if [ -z "$JSON_FILE" ]; then
    echo "ERRO: Não foi possível encontrar o arquivo JSON de credenciais na pasta ~/Downloads."
    exit 1
fi

cp "$JSON_FILE" ~/.gtasks/credentials.json
echo "Credenciais copiadas com sucesso de: $JSON_FILE"

echo "=== Configurando Atalho Padrão (Alias) ==="
# Adiciona um alias para que o gtasks sempre use a flag -g (Google API)
ALIAS_CMD="alias gtasks='gtasks -g'"

# Adiciona o atalho no .bashrc se o arquivo existir e ainda não possuir o atalho
if [ -f ~/.bashrc ]; then
    if ! grep -q "alias gtasks=" ~/.bashrc; then
        echo "" >> ~/.bashrc
        echo "# Forçar gtasks a usar Google API por padrão" >> ~/.bashrc
        echo "$ALIAS_CMD" >> ~/.bashrc
        echo "Atalho configurado no ~/.bashrc"
    else
        echo "Atalho já configurado no ~/.bashrc"
    fi
fi

# Adiciona o atalho no .zshrc se o arquivo existir e ainda não possuir o atalho
if [ -f ~/.zshrc ]; then
    if ! grep -q "alias gtasks=" ~/.zshrc; then
        echo "" >> ~/.zshrc
        echo "# Forçar gtasks a usar Google API por padrão" >> ~/.zshrc
        echo "$ALIAS_CMD" >> ~/.zshrc
        echo "Atalho configurado no ~/.zshrc"
    else
        echo "Atalho já configurado no ~/.zshrc"
    fi
fi

echo "=== Autenticando ==="
echo "Ao rodar o gtasks pela primeira vez, ele exibirá um link ou abrirá seu navegador"
echo "para que você autorize o acesso à sua conta do Google."
echo "Após autorizar, você poderá usar o comando 'gtasks' livremente!"
echo ""

# Rodamos o gtasks auth para disparar a tela de autorização
gtasks auth
