require './game'

class GameSession
  SAVES_FILE = 'saves.yml'

  def initialize
    @games = load_games
    @current_game = Game.new
  end

  def start
    puts "Hi! Welcome to Hangman Game.\n\n"
    while start?
      if load_game?
        number = get_number
        @game = load_game(number)
      end

      @game.start
    end
  end

  private

  def load_game?
    if @games.empty?
      puts "Let's start a new game!\n\n"
      return false
    end

    puts 'Do you want to load game? (Y/N)'
    answer = gets.chomp

    if answer.upcase == 'Y'
      true
    elsif answer.upcase == 'N'
      puts "OK. Let's start a new one.\n\n"
      false
    else
      puts "Let it be 'No'. Let's start a new one.\n\n"
      false
    end
  end

  def get_number
    number = ''

    loop do
      if load_last_game?
        number = @games.size
        break
      end

      print 'Please, enter the number of saved game: '
      number = gets.chomp.to_s

      break if number_correct?(number)

      puts 'Wrong number. Please try again.'
    end

    number.to_i
  end

  def load_last_game?
    puts 'Do you want to load last saved game? (Y/N)'
    answer = gets.chomp

    if answer.upcase == 'Y'
      true
    elsif answer.upcase == 'N'
      false
    else
      puts "Let it be 'Yes'"
      true
    end
  end

  def start?
    puts 'Do you want to play? (Y/N)'
    answer = gets.chomp.to_s

    if answer.upcase == 'Y'
      puts "Cool! Let's start!\n\n"
      true
    elsif answer.upcase == 'N'
      puts "Goodbye!\n\n"
      false
    else
      puts "Let it be 'Yes'\n\n"
      true
    end
  end

  def number?(string)
    string.scan(/[0-9]+/).size == 1
  end

  def number_correct?(number)
    number?(number) && number.to_i.between?(1, @games.size)
  end

  def load_game(number)
    @games.fetch(number - 1)
  end

  def load_games
    games = []

    YAML.load_stream(File.open('saves.yml')) do |game|
      games << game
    end

    games
  end
end

GameSession.new.start
