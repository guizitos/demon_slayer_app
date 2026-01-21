# Demon Slayer App

Este projeto é um aplicativo Flutter que lista personagens do anime **Demon Slayer**, permitindo busca, carregamento paginado e alternância entre tema claro e escuro. O app utiliza **Provider** para gerenciamento de estado e segue boas práticas de arquitetura modular, separando telas, provedores e serviços.

---

## Funcionalidades

1. **Lista de personagens**  
   - Exibe os personagens em uma lista scrollable.  
   - Carregamento paginado: quando o usuário chega próximo ao final da lista, mais personagens são carregados automaticamente.

2. **Busca de personagens**  
   - Campo de busca na tela inicial e em um diálogo modal.  
   - Debounce de 500ms para otimizar chamadas ao buscar.  
   - Mostra estado de carregamento durante a busca e mensagem quando nenhum personagem é encontrado.

3. **Tema claro e escuro**  
   - Usuário pode alternar entre tema claro e escuro.  
   - Tema padrão é baseado no modo do sistema, mas pode ser alterado pelo botão de tema na AppBar.

4. **Tratamento de erros**  
   - Caso ocorra algum erro ao carregar personagens, exibe uma tela com mensagem e botão para tentar novamente.

---

## Estrutura do Projeto

lib/

├── main.dart # Arquivo principal que inicia o app e configura os provedores

├── provedores/

│ ├── personagens_provedor.dart # Gerencia o estado da lista de personagens

│ └── tema_provedor.dart # Gerencia o estado do tema do aplicativo

├── servicos/

│ └── personagens_repositorio.dart # Responsável por buscar os dados dos personagens

├── telas/

│ ├── splash_tela.dart # Tela inicial de splash

│ └── lista_personagens_tela.dart # Tela principal com a lista de personagens

├── widgets/

│ ├── item_lista_personagem.dart # Widget individual de cada personagem

│ └── erro_view.dart # Widget para exibir erros


---

## Principais Classes

### `PersonagensProvedor`
- Extende `ChangeNotifier`.
- Responsável por armazenar a lista de personagens, controlar estados de carregamento (`carregando`, `carregandoMais`) e tratar buscas.
- Métodos principais:
  - `carregarMais()` → Carrega mais personagens quando o usuário rola a lista.
  - `buscar(String texto)` → Filtra personagens pelo nome.
  - `tentarNovamente()` → Tenta recarregar os personagens em caso de erro.

### `TemaProvedor`
- Extende `ChangeNotifier`.
- Armazena o estado atual do tema (`ThemeMode`).
- Método `alternarTema()` alterna entre `ThemeMode.light` e `ThemeMode.dark` e notifica os listeners.

### `ListaPersonagensTela`
- Tela principal do aplicativo.
- Contém:
  - `AppBar` com título, botão de busca e botão de alternar tema.
  - Campo de busca no header.
  - Lista de personagens (`CustomScrollView` + `SliverList`).
  - RefreshIndicator para atualizar os dados.
  - Botão de alternar tema na AppBar.

### `ItemListaPersonagem`
- Widget que renderiza cada personagem da lista, exibindo nome, imagem ou outros detalhes.

### `ErroView`
- Widget que exibe mensagem de erro e um botão para tentar novamente.

---

## Demonstração

Você pode assistir a uma demonstração do aplicativo no YouTube:  
[Link do vídeo](https://youtu.be/RVwfNfcpHrs?si=sdEXJ_a6RTL2qCAM)

## Dependências

- `flutter` >=3.x  
- `provider` → Para gerenciamento de estado.

Adicionar no `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5
  cupertino_icons: ^1.0.8
  http: ^0.13.6
  cached_network_image: ^3.2.3
