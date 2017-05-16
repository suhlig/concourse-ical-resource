# frozen_string_literal: true

require 'pathname'

RSpec.configure do |config|
end

def fixture(path)
  Pathname(__dir__).join('fixtures', path).read
end
