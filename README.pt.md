<p align="center"><img src="assets/bibliofuse-logo.png" alt="Logótipo BiblioFuse" width="180"></p>

<h1 align="center">BiblioFuse NAS</h1>

[English](README.md) | [Español](README.es.md) | [Français](README.fr.md) | [Nederlands](README.nl.md) | [Português](README.pt.md) | [Русский](README.ru.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Bahasa Indonesia](README.id.md) | [Bahasa Melayu](README.ms.md)

<p align="center">Uma biblioteca privada de ebooks e banda desenhada, autoalojada para Docker e Synology NAS.<br><a href="https://bibliofuse.com">Site BiblioFuse</a></p>

## Hospedagem e leitura gratuitas no navegador

O BiblioFuse NAS é gratuito para hospedar no Docker ou no Synology Container Manager. A biblioteca web e o leitor no navegador também são gratuitos; não é necessária subscrição para o servidor Docker ou a interface web.

Este repositório público de distribuição contém ficheiros de instalação e documentação. O código-fonte do servidor BiblioFuse é mantido separadamente e não está incluído aqui.

## Estado do produto

| Anfitrião ou cliente | Disponibilidade | Leitura e ligação |
| --- | --- | --- |
| Docker / Synology Container Manager | Beta público `0.1.8` | Servidor, interface de navegador e streaming nativo por Wi-Fi local gratuitos |
| Leitor web BiblioFuse | Incluído | CBZ, ZIP, CBR, RAR, EPUB, TXT, TEXT e Markdown |
| Apps iOS / visionOS lançadas com Docker | Suportado em Wi-Fi local | Descoberta Bonjour e streaming HTTPS fixado; Premium é aplicado pela app nativa |
| App Synology Package Center (`.spk`) | Lançamento público x86-64 | Pacote sem root com acesso guiado só de leitura a pastas partilhadas DSM existentes |
| Streaming iOS / visionOS pela app Synology | Suportado em Wi-Fi local | Descoberta Bonjour e streaming HTTPS fixado; Premium é aplicado pela app nativa |
| Anfitrião BiblioFuse Mac / PC | Produto separado | Recomendado quando o melhor desempenho de streaming nativo é prioritário |

Docker e o leitor de navegador continuam gratuitos. O streaming nativo é uma funcionalidade Premium da app iOS/visionOS e funciona na mesma rede Wi-Fi local.

## Idiomas do navegador

A app do navegador pode seguir o idioma do sistema ou ser definida em Definições para inglês, espanhol, francês, neerlandês, português, russo, chinês simplificado, japonês, coreano, indonésio ou malaio. Esta escolha fica apenas no navegador e não altera a configuração do servidor, metadados dos livros nem clientes nativos.

## Desempenho esperado

Um NAS sempre ligado é conveniente, privado e eficiente em energia, mas normalmente não prepara páginas de banda desenhada/arquivo tão depressa como um Mac ou PC moderno.

- **Anfitrião Mac ou PC:** melhor escolha para a experiência nativa de leitura mais fluida.
- **Anfitrião NAS:** ideal para uma biblioteca pessoal sempre disponível, com alguma latência esperada ao navegar ou abrir páginas não armazenadas em cache.
- **CPU do NAS importa:** indexação, descompressão, miniaturas e preparação da página seguinte usam CPU.
- **HDD contra SSD/NVMe:** SSD ou cache NVMe pode melhorar leituras frias e repetidas, mas não transforma uma CPU NAS de baixo consumo num Mac ou PC atual.
- **Modo contínuo de banda desenhada:** as páginas carregam progressivamente; uma breve pausa para preparar a próxima página sem cache pode ser normal.

O BiblioFuse armazena páginas preparadas em cache e começa a preparar páginas seguintes no servidor. A primeira visita a um arquivo grande pode ainda ser mais lenta.

## Antes de começar

Precisa de:

- anfitrião Intel/AMD de 64 bits ou ARM64 com Docker Compose, ou um modelo Synology com Container Manager;
- uma pasta persistente para configuração BiblioFuse;
- uma pasta descartável para cache;
- uma pasta com os seus livros;
- porta TCP `7343` livre para a interface web.

No Synology, crie por exemplo:

```text
/volume1/docker/bibliofuse/config
/volume1/docker/bibliofuse/cache
/volume1/books
```

Os caminhos podem ser diferentes. O BiblioFuse nunca precisa de acesso de escrita à pasta de livros.

## Instalar com Docker Compose

1. Transfira `docker/compose.yaml` e `docker/.env.example` deste repositório.
2. Copie `.env.example` para `.env`.
3. Edite `.env` e defina `CONFIG_PATH`, `CACHE_PATH`, `LIBRARY_PATH`, `PUID`, `PGID` e `BF_TIME_ZONE`. `LIBRARY_PATH` é a sua pasta no anfitrião.
4. Inicie o BiblioFuse:

```sh
docker compose up -d
```

5. Abra `http://<server-ip>:7343`.
6. Crie a primeira conta de administrador.
7. Abra Definições → **Anexar biblioteca**, escolha a localização **Biblioteca** mostrada ou uma subpasta e selecione **Atualizar**.

O Compose disponibiliza o `LIBRARY_PATH` escolhido como a localização amigável **Biblioteca**. Uma instalação nova não anexa pastas automaticamente: a seleção em Definições controla o que o BiblioFuse indexa. O contentor não encontra uma pasta do anfitrião que não tenha sido montada no Compose.

Veja o [guia de instalação Docker](docs/docker-install.pt.md) para atualizações, cópias de segurança, permissões, acesso remoto e resolução de problemas.

## Instalar com Synology Container Manager

Use `synology/compose.yaml` como projeto do Container Manager. Defina as variáveis do projeto com caminhos Synology absolutos, inicie o projeto e abra:

```text
http://<nas-ip>:7343
```

O projeto Synology monta DSM `/volume1` apenas para leitura e lista automaticamente as pastas partilhadas que o `PUID`/`PGID` escolhido pode ler. Não anexa nada até o administrador escolher uma pasta em Definições. As pastas de configuração e cache devem permitir escrita a esse utilizador/grupo numérico.

As pastas de biblioteca podem ser alteradas, desativadas ou desanexadas em Definições. Desanexar, inclusive a última, limpa o catálogo, metadados e progresso de leitura BiblioFuse dessa raiz sem apagar livros ou pastas.

Veja o [tutorial Synology](docs/synology-container-manager.pt.md) para a explicação completa. Não execute o projeto Docker e o pacote Synology nativo no mesmo NAS ao mesmo tempo: ambos usam deliberadamente as portas `7342` e `7343`; escolha um método de anfitrião por NAS.

## Pacote Synology nativo

O pacote genérico x86-64 é executado como a conta DSM restrita `BiblioFuseNAS` e não cria, move ou presume uma pasta de biblioteca. Definições explicam como dar a esta conta acesso apenas de leitura a uma pasta partilhada existente. O seletor lista apenas partilhas que a conta consegue ler; Anexar e Desanexar nunca apagam ficheiros de livros.

Veja o [guia do pacote Synology nativo](docs/synology-package.pt.md) para instalação e permissões.

## Atualizar biblioteca e formatos suportados

**Atualizar** verifica toda a árvore de pastas para adições, remoções e renomeações, reindexando apenas livros novos ou alterados. Em Definições, a atualização automática está desativada por predefinição; pode escolher diariamente ou semanalmente. Os horários usam intervalos de 30 minutos e `BF_TIME_ZONE` do contentor.

- Banda desenhada e arquivos de imagens: CBZ, ZIP, CBR e RAR
- Ebooks refluíveis: EPUB
- Texto simples: TXT, TEXT e Markdown

Arquivos de banda desenhada suportam leitura paginada e contínua. A posição de leitura EPUB e texto é guardada pela interface web. PDF não está incluído atualmente no leitor web Docker.

## Palavras-passe, segurança, cópias de segurança e atualizações

A primeira palavra-passe de administrador deve ter pelo menos 12 caracteres. Guarde-a num gestor de palavras-passe. Mantenha `7343` numa LAN de confiança ou atrás de um proxy reverso HTTPS de confiança; não a exponha por encaminhamento de porta do router. A porta `7342` é a API HTTPS fixada para clientes nativos e `7341` é reservada e nunca deve ser publicada.

Não existe recuperação por e-mail. Faça cópia de toda a pasta persistente de configuração; a pasta de cache é descartável e a biblioteca continua na sua própria pasta de anfitrião/NAS. Antes de atualizar, transfira uma cópia BiblioFuse em Definições e retenha uma cópia da configuração:

```sh
docker compose pull
docker compose up -d
```

Remover ou recriar o contentor não remove a conta ou catálogo se a mesma pasta de configuração permanecer montada. Desanexar uma biblioteca, em contraste, limpa catálogo, anotações e progresso dessa raiz e mantém os ficheiros apenas de leitura intactos.

## Transferências e ajuda

- **Imagem Docker:** `ghcr.io/mlt-solutions/bibliofuse-nas:0.1.8`
- **Modelos Docker e Synology Container Manager:** este repositório
- **Notas de versão e recursos para transferir:** GitHub Releases
- **Synology `.spk`:** GitHub Releases (`x86-64` DSM 7)
- **Produto e apps nativas:** [bibliofuse.com](https://bibliofuse.com)

Comece por [instalação e operações Docker](docs/docker-install.pt.md), [tutorial Synology Container Manager](docs/synology-container-manager.pt.md), [pacote Synology nativo](docs/synology-package.pt.md), [guia de desempenho](docs/performance.md) e [canais de lançamento](docs/releases-and-native-apps.md). Ao pedir ajuda, inclua modelo NAS/anfitrião, arquitetura CPU, versão Docker, formato do livro e registos recentes; nunca publique palavras-passe, chaves privadas, nomes sensíveis de ficheiros ou o conteúdo da pasta de configuração.
