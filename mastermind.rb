# frozen-string-literal: true

# Contains the game methods for use in the game. Some will have increased privacy to prevent the
# user from accessing the winning code
class Game
  scoreboard = Hash.new([' ', ' ', ' ', ' '])
  results = Hash.new([0, 0])
  round = 1
  win = false

  def display_board(board, results)
    i = 1
    12.times do
      puts board[i], ' | ', results[i]
      i += 1
    end
  end

  def decoder_submit(round)
    guess = []
    i = 1
    puts "Round #{round}.\nChoose from the following: R = red, O = orange, Y = Yellow, G = green, B = blue, P = purple"
    4.times do
      puts "What color do you choose for color #{i}"
      entry = gets.chop
      entry_checker(entry)
      guess << entry
    end
    guess
  end

  def entry_checker(string)
    colors = %w[R O Y G B P]
    unless colors.any?(string)
      puts 'Invalid choice.'
      puts 'Please Choose from the following: R = red, O = orange, Y = Yellow, G = green, B = blue, P = purple'
      string = gets.chop
    end
    string
  end

  def match?(guess, answer)
    m = 0
    guess.each_with_index do |v, i|
      if guess[i] == answer[i] {m += 1}
    end
    m
  end
end
