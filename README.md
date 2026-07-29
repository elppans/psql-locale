# psql-locale

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Script simples para garantir que a localidade pt_BR ISO-8859-1 esteja habilitada no sistema e reiniciar o serviço do PostgreSQL caso seja necessário. Útil em servidores Debian/Ubuntu onde o banc[...]

## O que faz
- Descomenta a entrada `pt_BR ISO-8859-1` em `/etc/locale.gen` e (se presente) em `/etc/locale.alias`.
- Executa `locale-gen` quando necessário.
- Reinicia o serviço do PostgreSQL (o script atual reinicia `postgresql@14-main.service`).
- Tenta adicionar uma entrada em `/etc/crontab` para rodar periodicamente (ver *Avisos* abaixo).

## Requisitos
- Sistema Debian/Ubuntu (ou compatível com `/etc/locale.gen` e `locale-gen`).
- Acesso root / sudo para editar `/etc/locale.*`, executar `locale-gen` e reiniciar serviços.
- systemd (para `systemctl restart postgresql@14-main.service`).
- Ajuste o nome do serviço PostgreSQL se sua instalação usar um nome diferente (ex.: `postgresql.service` ou outra versão).

## Instalação
1. Copie o script para `/usr/local/bin` e torne-o executável:
   ```
   sudo cp psql-locale.sh /usr/local/bin/psql-locale.sh
   sudo chmod +x /usr/local/bin/psql-locale.sh
   ```
2. Rode manualmente uma vez (ou deixe o cron rodar, se configurado):
>Rode como usuário normal. Se necessário será pedido a senha do sudo
   ```
   /usr/local/bin/psql-locale.sh
   ```

## Cron / Agendamento
O script tenta adicionar uma linha em `/etc/crontab` para executar periodicamente. Recomenda-se revisar e, se necessário, corrigir a linha de crontab para uma sintaxe válida. Exemplo recomendado[...]
```
# Executa o script a cada 55 minutos
*/55 * * * * root /usr/local/bin/psql-locale.sh
```
Verifique `/etc/crontab` após a primeira execução para garantir que a entrada foi adicionada corretamente.

## Uso típico
- Depois de instalar e executar o script, verifique:
  - Que a linha `pt_BR ISO-8859-1` está descomentada em `/etc/locale.gen`.
  - Que `locale-gen` completou sem erros.
  - Status do PostgreSQL:
    ```
    sudo systemctl status postgresql@14-main.service
    ```
  - Se o PostgreSQL usa outro nome/instância, ajuste a reinicialização no script.

## Avisos e recomendações
- O script edita arquivos críticos do sistema e reinicia serviços — revise o conteúdo antes de rodar em produção.
- A linha de crontab que o script insere deve ser verificada manualmente; confirme a sintaxe correta para seu sistema (`/etc/crontab` espera o campo de usuário após a expressão de tempo).
- Se você usa containers ou distribuições sem `locale-gen`/`/etc/locale.gen`, este script pode não ser aplicável.
- Faça backup de `/etc/locale.gen` e `/etc/locale.alias` antes de alterações automáticas, se necessário.

## Troubleshooting
- locale-gen retorna erro:
  - Rode `sudo locale-gen` manualmente e leia a saída.
- PostgreSQL não reinicia:
  - Cheque o nome do serviço com `systemctl list-units --type=service | grep postgres`.
  - Veja logs com `journalctl -u postgresql@14-main.service --no-pager`.
- Crontab não rodou:
  - Verifique `/etc/crontab` e o syslog (/var/log/syslog) por mensagens do cron.

## Contribuições
Correções, melhorias e sugestões são bem-vindas — abra uma issue ou envie um pull request. Se você planeja alterar o script para suportar outras distribuições ou versões do PostgreSQL, p[...]

## Licença
Este projeto está licenciado sob a Licença MIT — veja o arquivo [LICENSE](LICENSE) para os termos completos.
