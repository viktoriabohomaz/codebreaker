require_relative '../lib/codebreaker/version'
require_relative '../lib/codebreaker/game'

module Codebreaker
  def self.start_game
    Game.new.play
  end
end

Codebreaker.start_game