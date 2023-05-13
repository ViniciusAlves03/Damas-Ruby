require 'yaml'
require_relative 'tabuleiro.rb'

class Jogo

  def initialize(vermelho, branco)
    @jogadores, @tabuleiro = [vermelho, branco], Tabuleiro.new
  end

  def iniciar
    until @tabuleiro.perdeu?(@jogadores.first.color)
      if @jogadores.first.color == :red
        jogada_bot()
      else
        jogada_humano()
      end
      @jogadores.rotate!
    end
    puts "/////// #{vencedor()} ganhou! ///////"
  end

  def jogada_humano
    begin
      sequencia_movimentos = @jogadores.first.sequencia_movimentacao(@tabuleiro)
      @tabuleiro.realizar_movimentos(sequencia_movimentos)
    rescue DamasErro => e
      puts e.message
      retry
    end
  end

  def jogada_bot
    begin
      sequencia_movimentos = @jogadores.first.sequencia_movimentacao_bot(@tabuleiro)
      @tabuleiro.realizar_movimentos(sequencia_movimentos)
    rescue => e
      retry
    end
  end

  def vencedor
    @jogadores.last.color.to_s.capitalize
  end

end

class Jogador

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def sequencia_movimentacao(tabuleiro)
    @tabuleiro, movimentos = tabuleiro, []
    puts tabuleiro.render + "\n Vez do #{color.to_s.capitalize}"
    entrada = informar_movimento()

    return entrada if entrada.is_a?(Symbol)

    movimentos << entrada
    mais_movimentacao(movimentos)
  end

  def sequencia_movimentacao_bot(tabuleiro)
    @tabuleiro, movimentos = tabuleiro, []
    entrada = informar_movimento_bot()

    return entrada if entrada.is_a?(Symbol)

    movimentos << entrada
  end

  private

  def informar_movimento
    puts "Informe a posição da peça"
    posicaoInicial = gets.chomp

    puts "Informe a posição para onde a peça vai"
    posicaoFinal = converter_e_validar(gets.chomp)

    raise PecaInvalidaErro unless @tabuleiro[converter_e_validar(posicaoInicial)] && @tabuleiro[converter_e_validar(posicaoInicial)].color == self.color

    [converter_e_validar(posicaoInicial), posicaoFinal]
  end

  def mais_movimentacao(movimentos)
    puts "Mover novamente? (y/n)"
    if gets.chomp == "n"
      return movimentos
    end

    puts "Informe a posição para onde a peça vai"
    while (entrada = gets.chomp)
      if entrada == ""
        break
      end

      mover = [movimentos.last.last, converter_e_validar(entrada)]
      movimentos << mover

      puts "Informe o próximo movimento ou aperte enter para parar"
    end

    return movimentos
  end

  def converter_e_validar(entrada)
    if entrada.length == 2
      if entrada[0].match?(/\d/) && entrada[1].match?(/[a-zA-Z]/)
        numero = 8 - Integer(entrada[0])
        letra = entrada[1].downcase.ord - 'a'.ord
      elsif entrada[0].match?(/[a-zA-Z]/) && entrada[1].match?(/\d/)
        numero = 8 - Integer(entrada[1])
        letra = entrada[0].downcase.ord - 'a'.ord
      else
        puts "Entrada inválida"
        return
      end
    else
      puts "Entrada inválida"
      return
    end

    [numero, letra]
  end

  def informar_movimento_bot
    posicaoInicial = combinacao_jogada_bot(2)
    posicaoFinal = combinacao_jogada_bot(2)

    raise PecaInvalidaErro unless @tabuleiro[converter_e_validar(posicaoInicial)] && @tabuleiro[converter_e_validar(posicaoInicial)].color == self.color

    [converter_e_validar(posicaoInicial), converter_e_validar(posicaoFinal)]
  end

  def combinacao_jogada_bot(tamanho)
    letras = ('A'..'H').to_a + ('a'..'h').to_a
    numeros = (1..8).to_a
    combinacao = ""

    (tamanho / 2).times do
      combinacao += letras.sample + numeros.sample.to_s
    end

    combinacao
  end

end
