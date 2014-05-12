module Polytrix
  module Runners
    module Middleware
      class FeatureExecutor
        def initialize(app)
          @app   = app
        end

        def call(env)
          challenge_runner = env[:challenge_runner]
          env_file = env[:env_file]
          source_file = env[:source_file]
          relative_source_file = source_file.relative_path_from env[:basedir]
          command = challenge_runner.challenge_command(env_file, relative_source_file)
          process = challenge_runner.run_command command
          env[:result] = Result.new(process: process, source: env[:source_file])
          @app.call env
          env[:result]
        end
      end
    end
  end
end