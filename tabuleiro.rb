require_relative 'peças.rb'

class Tabuleiro

  #Método de classe que cria um tabuleiro vazio, representado por uma matriz 8x8.
  def self.criar_tabuleiro
    Array.new(8) { Array.new(8) }
  end

  def initialize(config = true)
    @grid = Tabuleiro.criar_tabuleiro
    config_grid() if config
  end

  #Sobrecarga do operador de acesso para obter a peça na posição posicao do tabuleiro. Retorna a peça na posição especificada.
  def [](posicao)
    raise ForaDoTabuleiro unless no_tabuleiro?(posicao)

    x, y = posicao
    @grid[x][y]
  end

  #Sobrecarga do operador de atribuição para colocar uma peça na posição posicao do tabuleiro. Atribui a peça à posição especificada.
  def []=(posicao, peca)
    raise ForaDoTabuleiro unless no_tabuleiro?(posicao)

    x, y = posicao
    @grid[x][y] = peca
  end

  #Verifica se a posição passada como argumento está dentro dos limites do tabuleiro.
  def no_tabuleiro?(posicao)
    posicao.all? { |i| i.between?(0, 7) }
  end

  #Executa a sequência de movimentos passada como argumento, se for válida.
  def realizar_movimentos(seq_movimentos)
    raise SequenciaDeMovimentosInvalidasErro unless seq_movimentos_validas?(seq_movimentos)
    realizar_movimentos!(seq_movimentos)
  end

  #Coloca uma peça na posição especificada do tabuleiro.
  def lugar_peca(peca, posicao)
    self[posicao] = peca
  end

  #Remove a peça na posição especificada do tabuleiro.
  def remover_peca(posicao)
    self[posicao] = nil
  end

  #Verifica se o jogador da cor especificada perdeu o jogo, ou seja, não possui mais peças no tabuleiro ou não possui movimentos válidos disponíveis.
  def perdeu?(color)
    test_tabuleiro = self.copia
    test_tabuleiro.pecas.none? { |peca| peca.color == color } ||
    test_tabuleiro.pecas.select { |peca| peca.color == color }
                       .all? { |peca| peca.mov_validos.empty? }
  end

  #Cria uma cópia do tabuleiro e de todas as suas peças.
  def copia
    test_tabuleiro = Tabuleiro.new(false)

    @grid.each_index do |linha|
      @grid[linha].each_with_index do |peca, coluna|
        posicao = [linha,coluna]
        peca = self[posicao]
        test_tabuleiro[posicao] = peca ? peca.copia(test_tabuleiro) : nil
      end
    end

    test_tabuleiro
  end

  #Retorna a representação visual do tabuleiro como uma string.
  def render
    "   A B C D E F G H\n" +
    @grid.map.with_index do |linha, i|
      "#{(8 - i)} " +
      linha.map.with_index do |peca, j|
        space = peca ? peca.render : "  "
        (i + j).odd? ? space.on_light_black : space
      end.join +
      " #{(8 - i)}"
    end.join("\n") +
    "\n   A B C D E F G H"
  end

  protected

  #Retorna um array de todas as peças no tabuleiro.
  def pecas
    @grid.flatten.compact
  end

  #Executa a sequência de movimentos passada como argumento
  def realizar_movimentos!(seq_movimentos)
    raise NenhumMovimentoInformado if seq_movimentos.empty?
    seq_movimentos.each_with_index do |mover, i|
      de_posicao = mover.first
      para_posicao = mover.last
      peca = self[de_posicao]

      deslizar = peca.realizar_deslizamento(para_posicao) if i.zero?
      if !i.zero? || (i.zero? && !deslizar)
        pular = peca.realizar_salto(para_posicao)
      end
      raise SequenciaDeMovimentosInvalidasErro unless deslizar || pular
    end
  end

  private

  #Verifica se a sequência de movimentos passada como argumento é válida.
  def seq_movimentos_validas?(seq_movimentos)
    test_tabuleiro = self.copia
    begin
      test_tabuleiro.realizar_movimentos!(seq_movimentos)
    rescue SequenciaDeMovimentosInvalidasErro
      return false
    end
    true
  end

  #Configura o tabuleiro inicial com as peças nas posições corretas.
  def config_grid
    # white: 5,6,7
    5.upto(7) do |linha|
      config_linha(linha, :white)
    end
    # red: 0,1,2
    0.upto(2) do |linha|
      config_linha(linha, :red)
    end
  end

  #Coloca uma linha de peças da cor especificada na linha do tabuleiro especificada.
  def config_linha(linha, color)
    8.times do |coluna|
      next if (linha + coluna).even?
      Peca.new(self, color, [linha, coluna])
    end
  end

end
