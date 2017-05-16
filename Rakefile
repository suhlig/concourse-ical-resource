# frozen_string_literal: true

require 'rspec/core/rake_task'
require 'rubocop/rake_task'

task default: ['spec:all']

namespace :spec do
  desc 'Run all specs'
  task all: %i[rubocop:auto_correct unit]

  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = 'spec/unit/**/*_spec.rb'
  end
end

RuboCop::RakeTask.new
