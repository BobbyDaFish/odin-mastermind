# frozen-string-literal: true
require 'pry-byebug'
# Contains the game methods for use in the game. Some will have increased privacy to prevent the
# user from accessing the winning code
class Game
  def initialize
    @scoreboard = Hash.new([' ', ' ', ' ', ' '])
    @results = Hash.new([0, 0])
    @answer = Game.generate_answer
    @round = 1
  end

  def inspect
    'New game!'
  end

  # show the board so far.
  def display_board
    i = 1
    12.times do
      puts "#{@scoreboard[i].join(',')} | #{@results[i].join(',')}"
      i += 1
    end
  end

  # get an array of decoder guesses
  def decoder_submit
    g = []
    i = 1
    puts "Round #{@round}.\nChoose from the following: R = red, O = orange, Y = Yellow, G = green, B = blue, P = purple"
    4.times do
      puts "What color do you choose for color #{i}"
      entry = gets.chop.upcase
      g << entry_checker(entry)
      i += 1
    end
    @scoreboard[@round] = g
  end

  # make sure each entry is valid.
  def entry_checker(string)
    colors = %w[R O Y G B P]
    unless colors.any?(string)
      puts 'Invalid choice.'
      puts 'Please Choose from the following: R = red, O = orange, Y = Yellow, G = green, B = blue, P = purple'
      string = gets.chop.upcase
    end
    string
  end

  # check each item in the guess array to see whether each index exactly matches the answer
  def match?
    m = 0
    g = @scoreboard[@round].flatten
    a = @answer.flatten
    g.each_with_index do |v, i|
      next unless v == a[i]

      m += 1
      match_process(g, a, i)
    end
    c = close_match?(g, a)
    @results[@round] = [m, c]
  end

  # find and return values that are present in answer, but in a different position.
  def close_match?(guess, answer)
    c = 0
    guess.each_with_index do |v, i|
      next unless answer.any?(v)

      answer.delete_at(answer.index(v))
      guess.delete_at(i)
      c += 1
    end
    c
  end

  # process the array to prevent false positives, and ensure accurate counts
  def match_process(guess, answer, index)
    answer.delete_at(index)
    guess.delete_at(index)
    answer.unshift(' ')
    guess.unshift('_')
  end

  def self.generate_answer
    a = []
    colors = %w[R O Y G B P]
    4.times do
      a << colors[rand(6)]
    end
    a
  end

  def end_game?
    if @scoreboard[@round] == @answer
      puts 'You win!'
      display_board
      true
    elsif @round == 12
      puts 'No guesses remain, you lose!'
      true
    else
      @round += 1
    end
  end
end

# begin game
start = Game.new
game_over = false

until game_over == true
  start.display_board
  start.decoder_submit
  start.match?
  game_over = start.end_game?
end
