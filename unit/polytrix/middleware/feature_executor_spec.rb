module Polytrix
  module Runners
    module Middleware
      describe FeatureExecutor do
        let(:app) { double('Middleware Chain') }
        let(:challenge_runner) { double('ChallengeRunner') }
        subject(:middleware) { described_class.new app }

        describe '#call' do
          let(:env) do
            {
              challenge: 'challenge_name',
              vars: { 'ENVIRONMENT' => 'VARIABLES' },
              challenge_runner: challenge_runner
            }
          end

          before do
            allow(challenge_runner).to receive(:find_challenge!).with('challenge_name').and_return '/path/to/script'
            allow(challenge_runner).to receive(:setup_env_vars).with(env[:vars]).and_return '/path/to/varfile'
            allow(challenge_runner).to receive(:challenge_command).with('/path/to/varfile', '/path/to/script').and_return 'some command to execute'
            allow(challenge_runner).to receive(:run_command).with('some command to execute').and_return Polytrix::Result.new(process: 'a', source: 'b', data: 'c')
            allow(app).to receive(:call).with(env)
          end

          # Most of this belongs in the ChallengeRunner...
          xit 'finds the challenge' do
          end

          xit 'setups the env vars' do
          end

          xit 'gets the command' do
          end

          it 'returns a result' do
            expect(middleware.call(env)).to be_an_instance_of Polytrix::Result
          end

          it 'continues the middleware chain' do
            expect(app).to receive(:call).with env
            middleware.call(env)
          end
        end
      end
    end
  end
end
