# frozen_string_literal: true

require 'pathname'
require 'aruba/rspec'
require 'rspec/json_matcher'
require 'webmock/rspec'

WebMock.disable_net_connect!
RSpec.configuration.include RSpec::JsonMatcher

def fixture(path)
  Pathname(__dir__).join('fixtures', path).read
end
