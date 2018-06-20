require 'yaml'

class Game
  TURNS = 10
  HINT = 1

  attr_reader :secret_code, :answer_user, :hint, :turns, :result, :message

  def initialize
    @secret_code = (1..4).map { rand(1..6) }
    @answer_user = ''
    @hint = HINT
    @turns = TURNS
    @result = []
    @message = YAML.load(File.open(File.join(File.dirname(__FILE__), "../data/info.yml")))
  end

  def input
    gets.strip
  end

  def puts_message(text)
    puts @message[:puts_message][text].to_s
  end

  def generate_answer
    @answer_user = input
    if @answer_user =~ /^[1-6]{4}$/
      @answer_user = @answer_user.split('').map!(&:to_i)
    else
      puts_message(:invalid_code)
      generate_answer
    end
  end

  def agree?
    input =~ /^(yes|y)$/i ? true : false
  end

  def puts_hint
    @hint -= 1
    @secret_code.shuffle.take(1).join
  end

  def win?
    @answer_user == @secret_code
  end

  def lose?
    @answer_user != @secret_code && @turns.zero?
  end

  def check_win
    return puts_message(:win) if win?
    return puts_message(:lose) if lose?
  end

  def reduction_turns
    @turns -= 1
  end

  def puts_result
    check_result
    p @result.join('')
    @result.clear
  end

  def play
    1.upto(TURNS) do |step|
      reduction_turns
      puts "Я загадал число, угадай какое? Попытка № #{step}. Осталось #{@turns}"
      generate_answer
      puts_result
      chek_hint if @hint >= 1
      check_win
      break if win? || lose?
    end
    play_again
  end

  def chek_hint
    puts_message(:hint)
    p puts_hint if agree?
  end

  def play_again
    initialize
    puts_message(:play_again)
    play if agree?
  end

  def check_result
    @pluses = []
    @minuses = []
    4.times do |i|
      if @secret_code.include?(@answer_user[i])
        @pluses.push('+') if @secret_code[i] == @answer_user[i]
        @minuses.push('-') if @secret_code[i] != @answer_user[i]
      end
    end
    @result.push(@pluses, @minuses).flatten!
  end
end
