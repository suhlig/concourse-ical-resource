# frozen_string_literal: true

guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{^spec/unit/(.*/)*.+_spec\.rb$})
  watch(%r{^lib/(?<module>.*/)(?<file>.+)\.rb$}) do |m|
    "spec/unit/#{m[:module]}#{m[:file]}_spec.rb"
  end
  watch('spec/spec_helper.rb') { 'spec' }
  watch(%r{^spec/fixtures}) { 'spec' }
end

guard :bundler do
  require 'guard/bundler'
  require 'guard/bundler/verify'
  watch('Gemfile')
  watch(/^.*\.gemspec/)
end
