require_relative 'game_messages_interface.rb'
require 'yaml'

module Codebreaker
  class Game
    #include GameMessagesInterface
    DEFAULT_TURNS_COUNT = 10
    DEFAULT_HINTS_COUNT = 1
    VALID_USER_ANSWER = /^[1-6]{4}$/

    attr_reader :secret_code, :answer_user, :hint, :turns, :result

    def initialize
      @secret_code = []
      @answer_user = ''
      @hint = DEFAULT_HINTS_COUNT
      @turns = DEFAULT_TURNS_COUNT
      @result = []
      @game_message_interface = GameMessagesInterface.new
    end

    def input
      gets.strip
    end

    def generate_secret_code
      @secret_code = (1..4).map {rand(1..6)}
    end

    def generate_answer
      @answer_user = input
      if @answer_user =~ VALID_USER_ANSWER
        @answer_user = @answer_user.split('').map!(&:to_i)
      else
        @game_message_interface.puts_message(:invalid_code)
        generate_answer
      end
    end

    def agree?
      input.match?(/^(yes|y)$/i)
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
      @game_message_interface.puts_message(:win) if win?
      @game_message_interface.puts_message(:lose) if lose?
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
      generate_secret_code
      1.upto(DEFAULT_TURNS_COUNT) do |_step|
        reduction_turns
        @game_message_interface.puts_message(:rules)
        generate_answer
        puts_result
        chek_hint
        check_win
        break if win? || lose?
      end
      play_again
    end

    def chek_hint
      return if @hint.zero?
      @game_message_interface.puts_message(:hint)
      p puts_hint if agree?
    end

    def play_again
      initialize
      @game_message_interface.puts_message(:play_again)
      if agree?
        play
      else
        @game_message_interface.puts_message(:game_over)
      end
    end

    def add_pluses
      @pluses = []
      4.times do |i|
        @pluses.push('+') if @secret_code[i] == @answer_user[i]
      end
    end

    def add_minuses
      @minuses = []
      common = @secret_code & @answer_user
      minuses_count = common.count - @pluses.count
      minuses_count.times { @minuses.push '-'}
    end

    def check_result
      add_pluses
      add_minuses
      @result.push(@pluses, @minuses).flatten!
    end
  end
end
