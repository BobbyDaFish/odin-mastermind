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
    @role = choose_role
  end

  # hide the answer
  def inspect
    'New game!'
  end

  # show the board so far.
  def display_board
    i = 0
    puts "-----Round #{@round}-----"
    12.times do
      puts "#{@scoreboard[i].join(',')} | #{@results[i].join(',')}"
      i += 1
    end
  end

  # get an array of decoder guesses
  def decoder_submit
    @scoreboard[@round - 1] = user_decoder if @role == '1'
    @scoreboard[@round - 1] = computer_decoder if @role == '2'
  end

  def computer_decoder
    g = []
    colors = %w[R O Y G B P]
    if @round == 1
      puts 'Create a code!'
      @answer = user_decoder
      g = Game.generate_answer
    else
      @scoreboard[@round - 2].each_with_index do |v, i|
        g << v if v == @answer[i]
        g << colors[rand(6)] if v != @answer[i]
      end
    end
    g
  end

  def user_decoder
    g = []
    i = 1
    puts 'Choose from the following: R = red, O = orange, Y = Yellow, G = green, B = blue, P = purple'
    4.times do
      puts "What color do you choose for color #{i}"
      entry = gets.chop.upcase
      g << entry_checker(entry)
      i += 1
    end
    g
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
    g = @scoreboard[@round - 1].flatten
    a = @answer.flatten
    g.each_with_index do |v, i|
      next unless v == a[i]

      m += 1
      match_process(g, a, i)
    end
    c = close_match?(g, a)
    @results[@round - 1] = [m, c]
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
    if @scoreboard[@round - 1] == @answer
      puts 'Decoder wins!'
      display_board
      true
    elsif @round == 12
      puts 'No guesses remain, decoder loses!'
      display_board
      true
    else
      @round += 1
    end
  end

  def choose_role
    puts 'Choose your role.\n Enter 1 to try to guess a code, 2 to create a code for the computer to guess.'
    r = gets.chop
    unless %w[1 2].any?(r)
      puts 'Invalid choice.'
      puts 'Enter 1 to try to guess a code, 2 to create a code for the computer to guess.'
      r = gets.chop
    end
    r
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
