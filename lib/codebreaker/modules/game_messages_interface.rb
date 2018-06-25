=begin
require 'yaml'
require 'pry'

module GameMessagesInterface
  attr_reader :message

  def initialize
    @message = YAML.load(File.open(File.join(File.dirname(__FILE__), "../data/info.yml")))
  end

  def puts_message(text)
    puts @message[:puts_message][text].to_s
  end
end
=end
