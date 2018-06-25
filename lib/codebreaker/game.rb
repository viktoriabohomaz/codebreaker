require_relative '../codebreaker/modules/game_messages_interface'
require 'yaml'
#require 'pry'

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
      @message = YAML.load(File.open(File.join(File.dirname(__FILE__), "../data/info.yml")))
    end

    def input
      gets.strip
    end

    def generate_secret_code
      @secret_code = (1..4).map {rand(1..6)}
    end

    def puts_message(text)
      puts @message[:puts_message][text].to_s
    end

    def generate_answer
      @answer_user = input
      if @answer_user =~ VALID_USER_ANSWER
        @answer_user = @answer_user.split('').map!(&:to_i)
      else
        puts_message(:invalid_code)
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
      puts_message(:win) if win?
      puts_message(:lose) if lose?
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
        puts_message(:rules)
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
      puts_message(:hint)
      p puts_hint if agree?
    end

    def play_again
      initialize
      puts_message(:play_again)
      if agree?
        play
      else
        puts_message(:game_over)
      end
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
    end
  end
end
