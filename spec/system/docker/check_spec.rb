# frozen_string_literal: true

require 'spec_helper'
require 'system/shared/check_examples'

describe 'when `check` is executed in a docker container', type: 'aruba' do
  before do
    `docker build -t suhlig/concourse-ical-resource:latest .`
    run 'docker run --rm --interactive suhlig/concourse-ical-resource /opt/resource/check'
  end

  include_examples 'check'
end
