#!/bin/bash

DATE="$(date +%y%m%d%H%M)"
PDVDIR="/Zanthus/Zeus/pdvJava"
BACKUPDIR="$PDVDIR/BACKUP_$DATE"
ARQUIVO_XXX="$PDVDIR/Q91Q0002.XXX"
PARAM_ECF="param.ecf"
SIMULA_ECF="simula.ecf"
PARAM_FILE="$PDVDIR/$PARAM_ECF"
SIMULA_FILE="$PDVDIR/$SIMULA_ECF"
ARCH=$(uname -m)
EXECUTAVEL=""

if [ -d "$PDVDIR" ]; then
    echo -e "\n[Criando a pasta de backup: $BACKUPDIR]\n"
    mkdir -m 777 -p "$BACKUPDIR"
    echo -e "\n[Pasta de backup criada com sucesso]\n"
else
    echo -e "\n[Erro: O diretório $PDVDIR não existe!]\n"
    exit 1
fi

if [[ "$ARCH" == "x86_64" ]]; then
    EXECUTAVEL="$PDVDIR/util_R90.xz64"
elif [[ "$ARCH" == "i686" || "$ARCH" == "i386" ]]; then
    EXECUTAVEL="$PDVDIR/util_R90.xz"
else
    echo -e "\n[Erro: Arquitetura do sistema não suportada]\n"
    exit 1
fi

# Verificar se o executável correspondente existe
if ! [ -e "$EXECUTAVEL" ]; then
    echo -e "\n[Erro: Arquivo $EXECUTAVEL não encontrado!]\n"
    exit 1
fi

echo "movendo arquivos de ZZZ Liença do PDV";
mv "$PDVDIR"/ZZZ* "$BACKUPDIR"

echo "movendo arquivos .TRA"
mv "$PDVDIR"/*.TRA "$BACKUPDIR"

echo "movendo arquivo ECF9NVOL.NV_";
mv "$PDVDIR"/ECF9NVOL.NV_ "$BACKUPDIR"

echo "movendo arquivo NUMERACCAIXA";
mv "$PDVDIR"/NUMERACAIXA_L.JSON "$BACKUPDIR"

echo "movendo arquivos NVW";
mv "$PDVDIR"/*.NVL "$BACKUPDIR"

echo "movendo arquivos .1VN";
mv "$PDVDIR"/*.1VN "$BACKUPDIR"

echo "movendo arquivos *.XXX";
mv "$PDVDIR"/*.XXX "$BACKUPDIR"

echo "movendo arquivos *.XML";
mv "$PDVDIR"/*.XML "$BACKUPDIR"
mv "$PDVDIR"/*.xml "$BACKUPDIR"

echo "movendo arquivo *.TXT";
mv "$PDVDIR"/*.TXT "$BACKUPDIR"
mv "$PDVDIR"/*.txt "$BACKUPDIR"

echo "movendo arquivos LIBERA91.BZ0";
mv "$PDVDIR"/LIBERA91.BZ0 "$BACKUPDIR"

if ! [ -e "$ARQUIVO_XXX" ]; then
    cd "$PDVDIR"
    echo -e "\n[Iniciando fabricação de Impressora, aguarde...]\n"
if [ -e "$PARAM_FILE" ]; then
        "$EXECUTAVEL" FABRICAR
        "$EXECUTAVEL" PROG="$PARAM_FILE"
        
        if [ -e "$SIMULA_FILE" ]; then
            "$EXECUTAVEL" PROG="$SIMULA_FILE"
        fi

        echo -e "\n[Impressora fabricada com sucesso]\n"
        sleep 3
    else
        echo -e "\n[Erro: Arquivo de configuração \".ecf\" não encontrado!]\n"
        exit 1
    fi
else
    echo -e "\n[Já existe uma Impressora fabricada]\n"
fi

