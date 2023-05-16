require_relative './lib/jogo.rb'

puts "Bem-vindo ao jogo de Damas"
puts "\n|Como jogar ?                                                  |
|Você deve informar a posição de acordo com o tabuleiro abaixo,|
|onde as letras são colunas e as linhas números. ex: A6.       |"
game = Jogo.new(Jogador.new(:red), Jogador.new(:white))
game.iniciar
