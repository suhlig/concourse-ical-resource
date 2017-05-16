# frozen_string_literal: true

require 'spec_helper'
require 'ical_resource'
require 'timecop'

# rubocop:disable Metrics/BlockLength
describe IcalResource::RangeParser do
  context 'with a valid spec' do
    subject(:parsed_range) { IcalResource::RangeParser.parse(parsed_spec) }

    before do
      Timecop.freeze(now) if defined?(now)
    end

    after do
      Timecop.return
    end

    context 'today' do
      let(:parsed_spec) { 'today' }
      let(:now) { Time.utc(2017, 5, 3, 0, 0, 0) }

      it 'returns a range' do
        expect(parsed_range).to be
        expect(parsed_range).to respond_to(:begin)
        expect(parsed_range).to respond_to(:end)
      end

      it 'starts at the beginning of today' do
        expect(parsed_range.begin).to eq(Time.utc(2017, 5, 3, 0, 0, 0))
      end

      it 'ends at the end of today' do
        expect(parsed_range.end).to eq(Time.utc(2017, 5, 3, 23, 59, 59))
      end
    end

    context 'yesterday' do
      let(:parsed_spec) { 'yesterday' }
      let(:now) { Time.utc(2017, 5, 3, 0, 0, 0) }

      it 'returns a range' do
        expect(parsed_range).to be
        expect(parsed_range).to respond_to(:begin)
        expect(parsed_range).to respond_to(:end)
      end

      it 'starts at the beginning of today' do
        expect(parsed_range.begin).to eq(Time.utc(2017, 5, 2, 0, 0, 0))
      end

      it 'ends at the end of today' do
        expect(parsed_range.end).to eq(Time.utc(2017, 5, 2, 23, 59, 59))
      end
    end
  end

  context 'unknown' do
    it 'returns a range' do
      expect { IcalResource::RangeParser.parse('sometime') }.to raise_error(IcalResource::RangeParser::InvalidRangeError)
    end
  end
end
