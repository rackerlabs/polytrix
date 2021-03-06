# -*- encoding: utf-8 -*-

Polytrix.validate 'Expected output for show', suite: 'Reports', scenario: 'show' do |challenge|
  expected_output = <<-eos
katas-hello_world-ruby:                            Fully Verified (2 of 2)
  Test suite:                                        Katas
  Test scenario:                                     hello world
  Implementor:                                       ruby
  Source:                                            sdks/ruby/katas/hello_world.rb
  Execution result:
    Exit Status:                                       0
    Stdout:
      Hello, world!
    Stderr:
  Validations:
    Hello world validator:                             ✓ Passed
    default validator:                                 ✓ Passed
  Data from spies:
eos
  cleaned_up = challenge.result.stdout.gsub(/\e\[(\d+)(;\d+)*m/, '').gsub("\r\n", "\n")
  expect(cleaned_up).to include(expected_output)
end
