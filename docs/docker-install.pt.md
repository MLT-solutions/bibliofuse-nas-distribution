[English](docker-install.md) | [Español](docker-install.es.md) | [Français](docker-install.fr.md) | [Nederlands](docker-install.nl.md) | [Português](docker-install.pt.md) | [Русский](docker-install.ru.md) | [简体中文](docker-install.zh-CN.md) | [日本語](docker-install.ja.md) | [한국어](docker-install.ko.md) | [Bahasa Indonesia](docker-install.id.md) | [Bahasa Melayu](docker-install.ms.md)

# Instalação e operações Docker

## Idioma do navegador

Após a configuração, abra Definições e escolha **Idioma**. O navegador pode seguir o idioma do sistema ou usar inglês, espanhol, francês, neerlandês, português, russo, chinês simplificado, japonês, coreano, indonésio ou malaio. A escolha é guardada apenas neste navegador e não afeta o contentor nem os metadados da biblioteca.

## 1. Escolha as pastas

| Finalidade | Caminho no contentor | Acesso necessário | Cópia de segurança |
| --- | --- | --- | --- |
| Conta, identidade, catálogo e definições | `/config` | Leitura/escrita | Sim |
| Páginas preparadas e miniaturas | `/cache` | Leitura/escrita | Não |
| A sua biblioteca de livros | `/library` | Apenas leitura | Separadamente |

Os caminhos do contentor não mudam. `CONFIG_PATH`, `CACHE_PATH` e `LIBRARY_PATH` selecionam as pastas reais no anfitrião. Docker não localiza uma biblioteca sozinho: monte a pasta antes do primeiro arranque e depois escolha-a em Definições.

## 2. Configure o Compose

Transfira os ficheiros em `docker/`, copie `.env.example` para `.env` e edite `.env`. Use caminhos absolutos numa instalação de servidor. No Linux, descubra os IDs numéricos de utilizador e grupo com:

```sh
id
```

Defina `PUID` e `PGID` para uma identidade que pode escrever nas pastas config/cache e ler a biblioteca. BiblioFuse funciona sem privilégios root.

## 3. Inicie e verifique

```sh
docker compose pull
docker compose up -d
docker compose ps
docker compose logs --tail=100 bibliofuse
```

Abra `http://<server-ip>:7343`. Crie o administrador e escolha **Anexar biblioteca** em Definições. O seletor mostra a montagem **Biblioteca** configurada e subpastas; uma instalação nova não tem raiz anexada até selecionar uma e atualizar.

Não execute este serviço Docker de rede de anfitrião ao lado do pacote Synology nativo no mesmo NAS: ambos usam HTTPS nativo `7342` e interface de navegador `7343`. A primeira atualização percorre a biblioteca inteira; as seguintes verificam a árvore mas reutilizam metadados de arquivos inalterados.

## 4. Adicione outra pasta de biblioteca

Cada raiz de biblioteca deve apontar para um caminho existente dentro do contentor. Adicione primeiro uma montagem só de leitura em `compose.yaml`, por exemplo:

```yaml
volumes:
  - "/srv/books:/library:ro"
  - "/srv/manga:/books/manga:ro"
environment:
  BF_LIBRARY_BROWSE_ROOTS: >-
    [{"name":"Library","path":"/library"},{"name":"Manga","path":"/books/manga"}]
```

Recrie o contentor e escolha Definições → Anexar biblioteca → **Manga**. Não introduza `/books/manga` nem o caminho anfitrião `/srv/manga` na interface web. Use **Alterar** se uma pasta montada foi renomeada; a identidade do catálogo é preservada. **Desativar** conserva os dados. **Desanexar** também funciona para a última raiz e remove catálogo, metadados e progresso dessa raiz sem eliminar ficheiros ou pastas.

## 5. Agende a atualização

Definições oferece Desativada, Diária e Semanal. Os horários usam intervalos de 30 minutos. Defina `BF_TIME_ZONE` para um fuso IANA válido, por exemplo `Asia/Kuala_Lumpur`.

## 6. Atualize

Prefira uma etiqueta de imagem numerada para implementações controladas. Faça cópia de `/config` e execute:

```sh
docker compose pull
docker compose up -d
docker image prune
```

`docker image prune` é opcional e remove dados de imagens não usados, não livros.

## 7. Pare ou desinstale

```sh
docker compose down
```

Isto remove contentor e rede, mas não as pastas anfitriãs de configuração, cache ou biblioteca. Para uma reposição explícita: pare o Compose, faça cópia das pastas indicadas por `CONFIG_PATH` e `CACHE_PATH`, renomeie-as como cópias retidas, crie pastas vazias novas com os mesmos nomes e permissões e volte a executar `docker compose up -d`. Nunca renomeie, esvazie ou elimine `LIBRARY_PATH`: a montagem é só de leitura.

## Acesso fora de casa e resolução de problemas

Não encaminhe diretamente a porta `7343` no router. Use proxy reverso HTTPS confiável com autenticação e certificado válido, ou a morada LAN através da sua própria rede VPN/Tailscale. O endereço Tailscale seguido de `:7343` é apenas acesso do navegador e não adiciona emparelhamento Docker às apps iOS/visionOS lançadas.

Se o seletor estiver vazio, confirme `LIBRARY_PATH`, verifique a montagem `/library:ro` com `docker compose config`, confirme que `PUID:PGID` lê a pasta e recrie o contentor após alterar uma montagem. Para acesso negado, corrija permissões ou `PUID`/`PGID`, não execute como root. Pausas em páginas frias são trabalho de CPU/disco; a cache persistente ajuda em leituras repetidas. Para reinícios repetidos, verifique:

```sh
docker compose ps
docker compose logs --tail=200 bibliofuse
```

Procure caminhos de montagem inválidos, permissões de escrita config/cache, conflitos de portas e `.env` incompleto. Não existe recuperação de palavra-passe por e-mail: recriar apenas o contentor não repõe a palavra-passe guardada em `/config`; use a reposição explícita apenas se aceitar perder conta, identidade, catálogo e definições BiblioFuse. A biblioteca fica intacta.
