# Cheatsheet Pessoal - Trilha Profarma (Dia 1)

## Docker Compose
* `docker-compose up -d` - Sobe a stack local (API + Banco) em background.
* `docker-compose up -d --build` - Força o rebuild das imagens e sobe a stack.
* `docker-compose ps` - Lista os containers ativos da stack local.
* `docker-compose logs -f <servico>` - Segue os logs em tempo real de um container.
* `docker-compose exec <servico> /bin/sh` - Entra no terminal interativo do container.
* `docker-compose down -v` - Derruba a stack e apaga os volumes de dados locais.

## Linux (Inspeção de Containers)
* `ps aux` - Lista todos os processos ativos no sistema.
* `ps aux | grep dotnet` - Filtra processos ativos que contêm a palavra "dotnet".
* `cat config.json | jq '.database.host'` - Lê um arquivo JSON e filtra uma propriedade específica.
* `tail -f /var/log/syslog | grep ERROR` - Monitora logs do sistema filtrando apenas por erros.
* `ls -la` - Lista todos os arquivos do diretório, incluindo ocultos, com detalhes.

## PowerShell (Scripts de Pipeline e Servidores Windows)
* `Get-Process` - Lista todos os processos rodando na máquina.
* `Get-Process | Where-Object {$_.ProcessName -like "*dotnet*"}` - Filtra processos por nome.
* `Get-Service` - Lista todos os serviços do Windows.
* `Select-Object` - Filtra colunas específicas de um output (ex: Id, ProcessName).