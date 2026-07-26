# Tutorial do Synology Container Manager

[English](synology-container-manager.md) | [Español](synology-container-manager.es.md) | [Français](synology-container-manager.fr.md) | [Nederlands](synology-container-manager.nl.md) | [Português](synology-container-manager.pt.md) | [Русский](synology-container-manager.ru.md) | [简体中文](synology-container-manager.zh-CN.md) | [日本語](synology-container-manager.ja.md) | [한국어](synology-container-manager.ko.md) | [Bahasa Indonesia](synology-container-manager.id.md) | [Bahasa Melayu](synology-container-manager.ms.md)

Este guia instala o servidor Docker gratuito e a interface web através do Container Manager. Para o pacote DSM nativo testado separadamente, consulte o [guia do pacote Synology](synology-package.md).

## Requisitos

- DSM 7 com Container Manager
- Um modelo Intel/AMD de 64 bits ou ARM64 suportado pela imagem publicada
- Permissão para criar pastas partilhadas e projetos do Container Manager

## 1. Criar pastas

No File Station, crie:

```text
docker/bibliofuse/config
docker/bibliofuse/cache
```

O projeto monta o DSM `/volume1` como somente leitura. As Definições listam as pastas partilhadas reais que a conta DSM configurada consegue ler; nenhuma delas é anexada automaticamente.

## 2. Selecionar o utilizador do contentor

O contentor tem de escrever na configuração/cache e ler a biblioteca. Use o UID e o GID numéricos de uma conta DSM dedicada com essas permissões. Por SSH:

```sh
id <username>
```

Os valores predefinidos `1026:100` são apenas exemplos e podem não corresponder ao seu NAS.

## 3. Criar o projeto

1. Transfira `synology/compose.yaml`.
2. Abra Container Manager → Project → Create.
3. Escolha um nome de projeto, como `bibliofuse`.
4. Carregue ou cole o ficheiro Compose.
5. Defina:
   - `CONFIG_PATH`, por exemplo `/volume1/docker/bibliofuse/config`
   - `CACHE_PATH`, por exemplo `/volume1/docker/bibliofuse/cache`
   - `PUID` e `PGID`
   - `BF_TIME_ZONE`, por exemplo `Asia/Kuala_Lumpur`
6. Crie/inicie o projeto.

## 4. Configuração inicial

Abra:

```text
http://<nas-ip>:7343
```

Crie uma palavra-passe de administrador com pelo menos 12 carateres. Em Definições, escolha **Attach library**, selecione uma pasta partilhada DSM apresentada ou uma subpasta de livros e, depois, escolha Refresh. Não é necessário introduzir nenhum caminho DSM ou do contentor. O seletor exclui partilhas ilegíveis com base no UID/GID do contentor selecionado.

As raízes podem ser alteradas, desativadas ou removidas. Desativar mantém os dados do catálogo. Remover elimina o catálogo, os metadados e o progresso de leitura do BiblioFuse dessa raiz sem apagar ficheiros ou pastas; remover a última raiz deixa uma biblioteca vazia válida.

## 5. Leitura e atualização

Refresh verifica toda a árvore montada e indexa livros novos, alterados, renomeados ou removidos. A atualização automática está desativada por predefinição; as Definições podem agendar uma atualização diária ou semanal.

O modo de banda desenhada contínua carrega as páginas progressivamente. Num DS923+ ou NAS semelhante, pode ainda ocorrer um breve atraso de carregamento em páginas de arquivos não colocadas em cache. Um Mac ou PC geralmente proporciona streaming nativo mais fluido, porque o seu CPU consegue descomprimir e preparar páginas mais depressa.

## 6. Cópia de segurança e atualização

- Inclua a pasta de configuração no Hyper Backup.
- A cache pode ser excluída.
- Transfira uma cópia de segurança do BiblioFuse nas Definições antes de atualizar.
- Mantenha a cópia de segurança da configuração anterior, pois as migrações de base de dados podem ser apenas de avanço.
- Obtenha a nova imagem e recrie o projeto sem alterar os mapeamentos de pastas.

Nunca selecione uma opção de desinstalação que elimine as pastas de configuração ou biblioteca mapeadas.

Para uma reposição de fábrica do Container Manager, pare o projeto, faça cópia de segurança e mude o nome das pastas configuradas de configuração e cache, crie novas pastas vazias com os nomes e permissões originais e reinicie. Nunca inclua a pasta da biblioteca nesta limpeza.

## 7. Limite de rede

- `7343`: interface gratuita no navegador numa LAN de confiança
- `7342`: API HTTPS fixada dos clientes nativos, descoberta em Wi-Fi local através de Bonjour
- `7341`: não publicar

O Container Manager e o `.spk` nativo emparelham com as aplicações iOS/visionOS lançadas em Wi-Fi local através de Bonjour. O streaming nativo continua sujeito ao limite da funcionalidade Premium da aplicação nativa; o Docker não fornece uma rota nativa manual/Tailscale.

Não execute este projeto do Container Manager ao lado do pacote Synology BiblioFuse nativo no mesmo NAS. Ambos os serviços associam `7342` e `7343`; escolha apenas um método de instalação.
