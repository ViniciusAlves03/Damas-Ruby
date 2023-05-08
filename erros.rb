class DamasErro < StandardError
end

class PecaInvalidaErro < DamasErro
  def message
    "Por favor, escolha uma posição com a sua peca nela"
  end
end

class MovimentoInvalidoErro < DamasErro
  def message
    "Movimento Inválido"
  end
end

class NenhumMovimentoInformado < DamasErro
  def message
    "Nenhum movimento Informado"
  end
end

class SequenciaDeMovimentosInvalidasErro < DamasErro
  def message
    "Sequência de movimentos inválida"
  end
end

class ForaDoTabuleiro < DamasErro
end
