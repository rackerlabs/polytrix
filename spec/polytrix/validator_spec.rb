require 'spec_helper'

module Polytrix
  describe 'Validator' do
    describe '#initialize' do
      let(:global_matcher) { Validator::UNIVERSAL_MATCHER }

      it 'accepts scope options and callback' do
        validator = Validator.new 'dummy', suite: 'java', scenario: 'hello world' do |_challenge|
          # Validate the challenge
        end
        expect(validator.suite).to eq('java')
      end

      it 'defaults suite and scenario to the universal matcher' do
        validator = Validator.new 'dummy' do |_challenge|
          # Validate
        end
        expect(validator.suite).to eq(Validator::UNIVERSAL_MATCHER)
        expect(validator.scenario).to eq(Validator::UNIVERSAL_MATCHER)
      end
    end

    describe '#should_validate?' do
      let(:challenge) do
        Fabricate(:challenge, suite: 'java', name: 'hello world')
      end

      it 'returns true if the scope matches the scope of the challenge' do
        expect(validator('java', 'hello world').should_validate? challenge).to be true
        expect(validator('java').should_validate? challenge).to be true
        expect(validator(/j/, /hello/).should_validate? challenge).to be true
      end

      it 'returns false if the scope does not match' do
        expect(validator('ruby', 'hello world').should_validate? challenge).to be false
        expect(validator('ruby').should_validate? challenge).to be false
        expect(validator(/r/, /hello/).should_validate? challenge).to be false
      end
    end

    describe '#validate' do
      let(:challenge) { Fabricate(:challenge, result: Result.new) }

      it 'calls the validation callback' do
        called = false
        validator = Validator.new 'dummy' do |_challenge|
          called = true
        end
        expect { validator.validate challenge }.to change { called }.from(false).to(true)
      end
    end

    def validator(*args)
      scope = {}
      scope[:suite] = args[0]
      scope[:scenario] = args[1] if args[1]
      Validator.new 'dummy', scope do |_challenge|
        # Dummy validator
      end
    end
  end
end
