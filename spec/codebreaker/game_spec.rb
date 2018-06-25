require 'spec_helper'

module Codebreaker
  describe Game do
    context '#generate_secret_code' do
      let(:game) { Game.new }
      before do
        game.generate_secret_code
      end

      it 'saves secret code' do
        expect(game.instance_variable_get(:@secret_code)).not_to be_empty
      end

      it 'saves 4 numbers secret code' do
        expect(game.instance_variable_get(:@secret_code).size).to eq 4
      end

      it 'saves secret code with numbers from 1 to 6' do
        expect(game.instance_variable_get(:@secret_code).join).to match(/[1-6]+/)
      end
    end

    context '#check_result' do
      before do
        subject.instance_variable_set :@secret_code, [1, 2, 3, 4]
      end

      it 'when first number the same' do
        subject.instance_variable_set :@answer_user, [1, 1, 1, 1]
        expect(subject.check_result).to eq(['+'])
      end

      it 'when two numbers match' do
        subject.instance_variable_set :@answer_user, [1, 2, 1, 2]
        expect(subject.check_result).to eq(['+', '+'])
      end

      it 'when three numbers match' do
        subject.instance_variable_set :@answer_user, [1, 2, 3, 1]
        expect(subject.check_result).to eq(['+','+','+'])
      end

      it 'when number is guessed but position is incorrect' do
        subject.instance_variable_set :@answer_user, [5, 6, 5, 2]
        expect(subject.check_result).to eq(['-'])
      end

      it 'when two numders is guessed but position is incorrect' do
        subject.instance_variable_set :@answer_user, [6, 3, 5, 2]
        expect(subject.check_result).to eq(['-', '-'])
      end

      it 'when three numders is guessed but position is incorrect' do
        subject.instance_variable_set :@answer_user, [4, 3, 6, 2]
        expect(subject.check_result).to eq(['-', '-', '-'])
      end

      it 'when all numbers guessed but two numbers have incorrect position' do
        subject.instance_variable_set :@answer_user, [1, 2, 4, 3]
        expect(subject.check_result).to eq(['+', '+', '-', '-'])
      end
    end

    context '#agree?' do
      it 'matches to pattern' do
        allow(subject).to receive(:input).and_return('y')
        expect(subject.agree?).to be_truthy
      end

      it 'matches to pattern' do
        allow(subject).to receive(:input).and_return('yes')
        expect(subject.agree?).to be_truthy
      end

      it 'matches to pattern' do
        allow(subject).to receive(:input).and_return('')
        expect(subject.agree?).to be_falsey
      end

      it 'matches to pattern' do
        allow(subject).to receive(:input).and_return('n')
        expect(subject.agree?).to be_falsey
      end
    end
  end
end