# frozen_string_literal: true

require 'spec_helper'
require 'ical_resource'
require 'timecop'

# rubocop:disable Metrics/BlockLength
describe IcalResource::RangeParser do
  context 'with valid input' do
    subject(:parsed_range) { IcalResource::RangeParser.parse(input) }

    before do
      Timecop.freeze(now) if defined?(now)
    end

    after do
      Timecop.return
    end

    shared_examples 'range' do
      it 'produces a range' do
        expect(parsed_range).to be
        expect(parsed_range).to respond_to(:begin)
        expect(parsed_range).to respond_to(:end)
      end
    end

    context 'today' do
      let(:input) { 'today' }
      let(:now) { Time.utc(2017, 5, 3, 0, 0, 0) }

      it_behaves_like 'range'

      it 'starts at the beginning of today' do
        expect(parsed_range.begin).to eq(Time.utc(2017, 5, 3, 0, 0, 0))
      end

      it 'ends at the end of today' do
        expect(parsed_range.end).to eq(Time.utc(2017, 5, 3, 23, 59, 59))
      end
    end

    context 'yesterday' do
      let(:input) { 'yesterday' }
      let(:now) { Time.utc(2017, 5, 3, 0, 0, 0) }

      it_behaves_like 'range'

      it 'starts at the beginning of today' do
        expect(parsed_range.begin).to eq(Time.utc(2017, 5, 2, 0, 0, 0))
      end

      it 'ends at the end of today' do
        expect(parsed_range.end).to eq(Time.utc(2017, 5, 2, 23, 59, 59))
      end
    end

    context 'this month' do
      let(:input) { 'this month' }
      let(:now) { Time.utc(2017, 4, 8, 0, 0, 0) }

      it_behaves_like 'range'

      it 'starts at the beginning of this month' do
        expect(parsed_range.begin).to eq(Time.utc(2017, 4, 1, 0, 0, 0))
      end

      it 'ends at the end of this month' do
        expect(parsed_range.end).to eq(Time.utc(2017, 4, 30, 23, 59, 59))
      end
    end

    context 'current month is in a leap year' do
      let(:input) { 'this month' }
      let(:now) { Time.utc(2016, 2, 5, 0, 0, 0) }

      it_behaves_like 'range'

      it 'starts at the beginning of this month' do
        expect(parsed_range.begin).to eq(Time.utc(2016, 2, 1, 0, 0, 0))
      end

      it 'ends at the end of this month' do
        expect(parsed_range.end).to eq(Time.utc(2016, 2, 29, 23, 59, 59))
      end
    end
  end

  it 'does not accept an unknown range' do
    expect { IcalResource::RangeParser.parse('some time') }.to raise_error(IcalResource::RangeParser::InvalidRangeError)
  end
end
