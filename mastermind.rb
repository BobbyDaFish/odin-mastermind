# frozen-string-literal: true
require 'pry-byebug'
# Contains the game methods for use in the game. Some will have increased privacy to prevent the
# user from accessing the winning code
class Game
  # show the board so far.
  def self.display_board(board, results)
    i = 1
    12.times do
      puts board[i].join(',') + ' | ' + results[i].join(',')
      i += 1
    end
  end

  # get an array of decoder guesses
  def self.decoder_submit(round)
    g = []
    i = 1
    puts "Round #{round}.\nChoose from the following: R = red, O = orange, Y = Yellow, G = green, B = blue, P = purple"
    4.times do
      puts "What color do you choose for color #{i}"
      entry = gets.chop.upcase
      g << entry_checker(entry)
      i += 1
    end
    g
  end

  # make sure each entry is valid.
  def self.entry_checker(string)
    colors = %w[R O Y G B P]
    unless colors.any?(string)
      puts 'Invalid choice.'
      puts 'Please Choose from the following: R = red, O = orange, Y = Yellow, G = green, B = blue, P = purple'
      string = gets.chop.upcase
    end
    string
  end

  # check each item in the guess array to see whether each index exactly matches the answer
  def self.match?(guess, answer)
    m = 0
    guess.each_with_index do |v, i|
      next unless v == answer[i]

      m += 1
      answer.delete_at(i)
      guess.delete_at(i)
    end
    c = close_match?(guess, answer)
    [m, c]
  end

  # find and return values that are present in answer, but in a different position.
  def self.close_match?(guess, answer)
    c = 0
    guess.each_with_index do |v, i|
      next unless answer.any?(v)

      answer.delete_at(answer.index(v))
      guess.delete_at(i)
      c += 1
    end
    c
  end

  def self.generate_answer
    a = []
    colors = %w[R O Y G B P]
    4.times do
      a << colors[rand(6)]
    end
    a
  end
end

scoreboard = Hash.new([' ', ' ', ' ', ' '])
results = Hash.new([0, 0])
round = 1
win = false
# begin game
answer = Game.generate_answer
while win == false || round <= 12
  Game.display_board(scoreboard, results)
  guess = Game.decoder_submit(round)
  scoreboard[round] = guess
  results[round] = Game.match?(guess, answer)
  if guess == answer
    win = true
    puts 'You win!'
    Game.display_board(scoreboard, results)
  else
    round += 1
  end
end
