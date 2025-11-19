# Damas Ruby - Jogo de Damas via Terminal

![Ruby](https://img.shields.io/badge/ruby-%23CC342D.svg?style=for-the-badge&logo=ruby&logoColor=white)
![Gem Colorize](https://img.shields.io/badge/gem-colorize-%23C72C48?style=for-the-badge)
![CLI](https://img.shields.io/badge/CLI-Terminal-4D4D4D?style=for-the-badge&logo=gnu-bash&logoColor=white)

Este é o repositório do **Damas Ruby**, uma implementação clássica do jogo de Damas desenvolvida para rodar diretamente no terminal.

O projeto foi construído utilizando **Programação Orientada a Objetos (POO)** para simular a lógica de tabuleiro, peças e regras de movimentação. O jogo apresenta uma interface visual colorida no console e permite uma partida entre um jogador humano e um Bot.

## ✨ Principais Funcionalidades

* **Modo Single Player:**
    * O jogador humano controla as peças **Brancas**.
    * Um algoritmo de **Bot** controla as peças **Vermelhas**, realizando jogadas automáticas.
* **Lógica de Movimentação Completa:**
    * Validação de movimentos simples (deslizamento) e capturas (saltos).
    * Impedimento de movimentos inválidos ou fora do tabuleiro.
* **Promoção de Peças:**
    * Peças que atingem a extremidade oposta do tabuleiro são promovidas a **Damas** (representadas pelo símbolo 🅚), ganhando movimentação especial.
* **Interface Visual:**
    * Renderização do tabuleiro atualizada a cada turno via terminal.
    * Uso da gem `colorize` para diferenciar visualmente as peças e o tabuleiro.
* **Tratamento de Erros:**
    * Sistema robusto de exceções para garantir que entradas inválidas não quebrem o fluxo do jogo (ex: `PecaInvalidaErro`, `MovimentoInvalidoErro`).

## 🚀 Tecnologias Utilizadas

* **Linguagem:** Ruby
* **Bibliotecas (Gems):** Colorize (para estilização da saída no terminal)
* **Paradigma:** Orientação a Objetos (Classes para Jogo, Tabuleiro, Peças, Jogador)
* **Armazenamento de Dados:** YAML (requerido no código fonte)

## 📋 Pré-requisitos

Para executar este jogo localmente, você precisará ter o seguinte instalado:

* **Ruby** (v2.5 ou superior)
* **Gem Colorize**

## ⚙️ Instalação e Execução

Siga os passos abaixo para baixar e rodar o jogo em sua máquina.

1.  **Clone o repositório:**
    ```bash
    git clone [LINK_DO_SEU_REPOSITORIO]
    cd Damas-Ruby
    ```

2.  **Instale as dependências:**
    O jogo utiliza a gem `colorize` para renderizar as cores. Instale-a com o comando:
    ```bash
    gem install colorize
    ```

3.  **Execute o jogo:**
    Inicie o arquivo principal `damas.rb` através do interpretador Ruby:
    ```bash
    ruby damas.rb
    ```

## 🏗️ Estrutura do Projeto

A estrutura de arquivos segue uma organização lógica separando as responsabilidades das classes em uma pasta `lib`.

```sh
Damas-Ruby/
├── lib/
│   ├── erros.rb         # Definição de classes de exceção personalizadas.
│   ├── jogo.rb          # Lógica principal do fluxo do jogo e turnos.
│   ├── peças.rb         # Comportamento das peças (movimento, promoção, renderização).
│   └── tabuleiro.rb     # Lógica da grid, verificação de vitória e renderização do board.
└── damas.rb             # Ponto de entrada (Entry point) da aplicação.
```

## 🎮 Como Jogar

Ao iniciar o jogo, o tabuleiro será exibido no terminal. As colunas são representadas por Letras (A-H) e as linhas por Números (1-8).

# Sistema de Coordenadas
O jogo solicitará a entrada em dois passos para cada jogada:

    1. Posição da Peça: Informe a coordenada da peça que deseja mover (ex: C3).

    2. Destino: Informe a coordenada para onde a peça deve ir (ex: D4).

| Exemplo de Entrada | Descrição |
| :--- | :--- |
| `C3` | Seleciona a peça branca na coluna C, linha 3. |
| `B4` | Move a peça selecionada para a coluna B, linha 4 (diagonal esquerda). |
| `D4` | Move a peça selecionada para a coluna D, linha 4 (diagonal direita). |

---

## 🧑‍💻 Autor <a id="autor"></a>

<p align="center">Desenvolvido por Vinícius Alves <strong><a href="https://github.com/ViniciusAlves03">(eu)</a></strong>.</p>

---
