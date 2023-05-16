require 'colorize'
require_relative 'erros.rb'

class Peca

  attr_reader :posicao, :color

  def initialize(tabuleiro, color, posicao)
    @tabuleiro, @color, @posicao = tabuleiro, color, posicao

    tabuleiro.lugar_peca(self, @posicao)
    @promover = false
  end

  #Cria uma cópia da peça no tabuleiro passado como argumento. Se a peça original foi promovida, a peça duplicada também é promovida.
  def copia(tabuleiro)
    nova_peca = Peca.new(tabuleiro, color, posicao)
    nova_peca.promover if promovida?
    nova_peca
  end

  #Retorna todos os movimentos válidos que a peça pode fazer, considerando deslizamentos e saltos.
  def mov_validos
    todos_movimentos = movimentos(:slide) + movimentos(:jump)
    todos_movimentos.select { |mover| realizar_deslizamento(mover) || realizar_salto(mover) }
  end

  #Realiza um deslizamento da peça para a posição pos_deslizar se for válido.
  def realizar_deslizamento(pos_deslizar)
    return false unless pos_deslizar_valida?(pos_deslizar)

    @tabuleiro.remover_peca(posicao)
    @posicao = pos_deslizar
    @tabuleiro.lugar_peca(self, pos_deslizar)
    promover if promovivel? && !promovida?
    true
  end

  #Realiza um salto da peça para a posição pos_pulo se for válido.
  def realizar_salto(pos_pulo)
    return false unless pos_pulo_valida?(pos_pulo)
    pos_adjacente = pos_adjacente(pos_pulo)

    # Verifica se a posição de destino está livre
    return false unless @tabuleiro[pos_pulo].nil?

    @tabuleiro.remover_peca(posicao)
    @tabuleiro.remover_peca(pos_adjacente)
    @tabuleiro.lugar_peca(self, pos_pulo)
    @posicao = pos_pulo
    promover if promovivel? && !promovida?
    true
  end

  #Retorna a representação visual da peça como uma string colorida, usando um símbolo diferente para peças promovidas e não promovidas.
  def render
    simbolo = promovida? ? "🅚" : "⬤ "
    simbolo.colorize(color)
  end

  private

  #Verifica se a posição passada como argumento está dentro dos limites do tabuleiro.
  def no_tabuleiro?(posicao)
    posicao.all? { |i| i.between?(0, 7) }
  end

  #Retorna todas as posições possíveis de movimento (deslizamento ou salto) para a peça, considerando a direção e distância.
  def movimentos(mover)
    multiplicador = mover == :slide ? 1 : 2
    x, y = posicao
    movimentos = diferencas_movimentação.map do |dx, dy|
      [x + dx * multiplicador, y + dy * multiplicador]
    end
    movimentos.select { |mover| @tabuleiro.no_tabuleiro?(mover) }
  end

  #Retorna as diferenças de movimento para a peça, dependendo se ela está promovida e de sua cor.
  def diferencas_movimentação
    diferencas = [[1, 1], [1, -1]]
    diferencas += diferencas.map{ |linha| [linha.first * -1, linha.last] } if promovida?
    diferencas.map! { |linha| [linha.first * -1, linha.last] } if color == :white
    diferencas
  end

  #Retorna a posição adjacente entre a posição atual da peça e a posição pos_pulo.
  def pos_adjacente(pos_pulo)
    [(posicao.first + pos_pulo.first) / 2, (posicao.last + pos_pulo.last) / 2]
  end

  #Verifica se a posição de deslizamento é válida, ou seja, se a posição está entre os movimentos possíveis de
  # deslizamento e se a posição está vazia.
  def pos_deslizar_valida?(pos_deslizar)
    movimentos(:slide).include?(pos_deslizar) && @tabuleiro[pos_deslizar].nil?
  end

  #Verifica se a posição de salto é válida, considerando a direção do movimento, se a peça está se movendo na diagonal,
  # se está na direção correta e se há uma peça adversária na direção e a posição de destino está livre.
  def pos_pulo_valida?(pos_pulo)
    direcao = [(pos_pulo.first - posicao.first) <=> 0, (pos_pulo.last - posicao.last) <=> 0]

    # Verifica se a peça está se movendo na diagonal
    return false unless (pos_pulo.first - posicao.first).abs == (pos_pulo.last - posicao.last).abs

    # Verifica se a peça está se movendo na direção correta
    return false if !promovida? && color == :white && direcao.first != -1
    return false if !promovida? && color == :red && direcao.first != 1

    # Verifica se a peça é comum e está tentando se mover mais de duas casas
    if color == :red
      return false if !promovida? && (pos_pulo.first - posicao.first).abs > 2
    end
    # Verifica se há uma peça adversária na direção e se a posição de destino está livre
    pos_atual = [posicao.first + direcao.first, posicao.last + direcao.last]
    tem_oponente = false

    while no_tabuleiro?(pos_atual) && pos_atual != pos_pulo
      if @tabuleiro[pos_atual] && @tabuleiro[pos_atual].color != self.color
        return false if tem_oponente # Não pode capturar mais de uma peça adversária
        tem_oponente = true if !tem_oponente && @tabuleiro[pos_atual].color != self.color
      elsif @tabuleiro[pos_atual]
        return false # Peça da mesma cor no caminho
      end
      pos_atual = [pos_atual.first + direcao.first, pos_atual.last + direcao.last]
    end

    # Para peças não promovidas, verifica se há um oponente, caso contrário, retorna verdadeiro
    return tem_oponente if !promovida?

    # Para peças promovidas (dama), permite movimentos livres na diagonal, mas verifica se a captura é válida quando há um oponente
    if tem_oponente
      pos_adjacente = pos_adjacente(pos_pulo)
      return false if @tabuleiro[pos_adjacente] && @tabuleiro[pos_adjacente].color == self.color # Peça da mesma cor no caminho
      return @tabuleiro[pos_pulo].nil? # A posição de destino deve estar livre
    else
      return true
    end
  end

  protected

  #Promove a peça, definindo o atributo @promover como verdadeiro.
  def promover
    @promover = true
  end

  #Retorna verdadeiro se a peça estiver promovida, caso contrário, retorna falso.
  def promovida?
    @promover
  end

  #Verifica se a peça é promovível, ou seja, se está na última linha do tabuleiro, dependendo de sua cor.
  def promovivel?
    linha = posicao.first
    color == :white ? linha == 0 : linha == 7
  end

end
