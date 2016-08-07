require 'yaml'

class Game
  WORDS_FILE = 'words.txt'
  SAVES_FILE = 'saves.yml'

  def initialize
    @secret_word = random_word
    @visible_word = '_' * @secret_word.length
    @amount_of_allowable_mistakes = 6
  end

  def start
    show_word

    until end_of_game?
      check_letter

      show_word

      save_dialog
    end

    result
  end

  private

  def random_word
    words = choose_words

    random_index = rand(words.size)

    words.fetch(random_index)
  end

  def read_words
    words = []

    File.open(WORDS_FILE, 'r') do |file|
      words = file.read.split(/\s/)
    end

    words
  end

  def choose_words
    words = read_words
    words.select do |word|
      word.length.between?(5, 12)
    end
  end

  def show_word
    print 'Secret word: '
    puts "#{@visible_word}\n\n"
  end

  def show_right_answer
    print 'Right answer: '
    puts "#{@secret_word}\n"
  end

  def player_win?
    @amount_of_allowable_mistakes > 0 && !@visible_word.include?('_')
  end

  def player_lost?
    @amount_of_allowable_mistakes == 0
  end

  def end_of_game?
    player_lost? || player_win?
  end

  def get_letter
    char = ''

    loop do
      print 'Please, enter a letter: '
      char = gets.chomp

      break if letter?(char)

      puts 'Error! Please enter a letter'
    end

    char
  end

  def letter?(char)
    return false unless char.to_s.length == 1

    #if char is a letter char.scan return an array with this letter
    #else this array is empty
    char.scan(/[a-zA-Z]/).size > 0
  end

  def save_game
    saved_game =  YAML.dump(self)
    File.open(SAVES_FILE, 'a') { |file| file.puts saved_game }
    puts "You've saved game.\n\n"
  end

  def result
    if player_win?
      puts "My congratulations! You've won.\n"
    elsif player_lost?
      puts "Game over. Right answer is #{@secret_word}.\n"
    end
  end

  def save_dialog
    puts 'Do you want to save the game? (Y/N)'
    answer = gets.chomp.to_s

    if answer.upcase == 'Y'
      save_game
    elsif answer.upcase == 'N'
      puts "OK. Let's continue.\n\n"
    else
      puts "Let it be 'Yes'"
      save_game
    end
  end

  def check_letter
    letter = get_letter

    letters = @secret_word.downcase.split('')

    if letters.include?(letter.downcase)
      letters.each_with_index do |char, index|
        next unless char == letter.downcase

        @visible_word[index] = @secret_word[index]
      end
      puts "\nGreat! Secret word has this letter.\n"
    else
      @amount_of_allowable_mistakes -= 1
      puts "\nUnfortunately, secret word doesn't consist letter #{letter}.\n"
    end
  end
end