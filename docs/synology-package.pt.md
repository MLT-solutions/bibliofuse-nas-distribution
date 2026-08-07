[English](synology-package.md) | [Español](synology-package.es.md) | [Français](synology-package.fr.md) | [Nederlands](synology-package.nl.md) | [Português](synology-package.pt.md) | [Русский](synology-package.ru.md) | [简体中文](synology-package.zh-CN.md) | [日本語](synology-package.ja.md) | [한국어](synology-package.ko.md) | [Bahasa Indonesia](synology-package.id.md) | [Bahasa Melayu](synology-package.ms.md)

# Pacote Synology nativo

## Estado atual

O pacote x86-64 `0.1.0-0043` é a versão DSM 7. Fornece um fluxo de acesso simples, sem root:

- nenhum nome de pasta partilhada, endereço NAS ou caminho de biblioteca está incorporado;
- os livros permanecem nas pastas partilhadas DSM existentes;
- BiblioFuse não pode conceder acesso a si próprio nem alterar permissões DSM;
- Definições explicam como conceder acesso apenas de leitura à conta restrita do pacote;
- Anexar e Desanexar controlam apenas a indexação e nunca eliminam ficheiros da biblioteca.

O pacote não é um contentor. O Package Center gere o ciclo de vida, o ícone do menu principal e a conta interna restrita.

## Idioma do navegador

Em Definições, escolha **Idioma** para seguir o idioma do sistema ou selecionar inglês, espanhol, francês, neerlandês, português, russo, chinês simplificado, japonês, coreano, indonésio ou malaio. A seleção fica apenas neste navegador e sobrevive a atualizações do pacote.

## Instale e conceda acesso

1. Instale o `.spk` x86-64 por Package Center → Instalação manual.
2. Abra BiblioFuse NAS e crie administrador com pelo menos 12 carateres.
3. Abra Definições → **Mostrar os 6 passos**, ou siga-os aqui:
   1. Abra DSM **Painel de controlo** → **Pasta partilhada**.
   2. Selecione a pasta partilhada existente com os seus livros e escolha **Editar**.
   3. Abra **Permissões**.
   4. Altere a lista para **Utilizador interno do sistema**.
   5. Encontre `BiblioFuseNAS`, conceda **Apenas leitura** e guarde.
   6. Volte a BiblioFuse → **Anexar biblioteca** → **Atualizar acesso**, e escolha a partilha ou uma subpasta.
4. Selecione **Atualizar livros**.

Não é necessário introduzir caminhos `/volume1/...` ou `/var/packages/...`, nem reiniciar o pacote após conceder acesso.

## Ciclo de vida dos dados

- **Desativar:** mantém o catálogo e permite ativar novamente o anexo.
- **Desanexar:** limpa catálogo, metadados e progresso de leitura desse anexo.
- **Atualizar pacote:** preserva conta, identidade de certificado, definições, catálogo e cache.
- **Desinstalar pacote:** apaga todos os dados pertencentes ao BiblioFuse: conta, palavra-passe, identidade, definições, catálogo, registos e cache.
- **Biblioteca:** fica sempre fora dos dados do pacote e nunca é eliminada.

Uma atualização do pacote privado de teste v8 migra o alias de partilha do pacote para o caminho normal do volume DSM preservando a identidade da raiz.

## Rede e limite de suporte atual

- `7343/tcp`: biblioteca e leitor de navegador gratuitos na LAN confiável.
- `7342/tcp`: escuta HTTPS fixada para cliente nativo.
- `7341/tcp`: reservada e nunca usada.

No arranque, o pacote obtém o endereço LAN privado ativo do DSM e anuncia Bonjour diretamente do anfitrião NAS. Se DSM Tailscale estiver ativo, o endereço `tailscale0` é incluído como sugestão opcional de ligação manual. Respostas JSON nativas grandes incluem `Content-Length` para compatibilidade com o transporte Apple fixado lançado.

O emparelhamento em Wi-Fi local com apps iOS/visionOS lançadas é suportado por Bonjour e HTTPS fixado. O streaming nativo continua sujeito ao limite Premium da app nativa.

## Arquitetura

O pacote inicial suporta Synology x86-64. ARM64 continua não criado nem testado. Confirme a arquitetura CPU do NAS antes de transferir uma versão.
