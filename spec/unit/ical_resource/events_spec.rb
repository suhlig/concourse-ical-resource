# frozen_string_literal: true

require 'spec_helper'
require 'ical_resource'

# rubocop:disable Metrics/BlockLength
describe 'Runtime PMC meetings' do
  let(:ical_file) { fixture('runtime_pmc_meetings.ical') }
  let(:calendar) { Icalendar::Calendar.parse(ical_file).first }
  subject(:occurrences) { IcalResource::Occurrences.new(calendar).within(range) }

  context 'across the year' do
    let(:range) { Time.utc(2017, 1, 1, 0, 0, 0)..Time.utc(2017, 12, 31, 23, 59, 59) }

    it 'happen at least once' do
      expect(occurrences).to_not be_empty
    end

    it 'all have a summary' do
      expect(occurrences).to all(satisfy { |o| !o.event.summary.empty? })
    end
  end

  context 'in May 2017' do
    let(:range) { Time.utc(2017, 5, 1, 0, 0, 0)..Time.utc(2017, 5, 31, 23, 59, 59) }

    it 'happen three times' do
      expect(occurrences.size).to eq(3)
    end

    context 'the first occurrence' do
      let(:occurrence) { occurrences[0].occurrence }

      it 'first takes place on May 3' do
        expect(occurrence.start_time).to eq(Time.parse('2017-05-03 21:30 UTC'))
      end
    end

    context 'the second occurrence' do
      let(:occurrence) { occurrences[1].occurrence }

      it 'first takes place on May 16' do
        expect(occurrence.start_time).to eq(Time.parse('2017-05-16 17:30 UTC'))
      end
    end

    context 'the third occurrence' do
      let(:occurrence) { occurrences[2].occurrence }

      it 'first takes place on May 31' do
        expect(occurrence.start_time).to eq(Time.parse('2017-05-31 21:30 UTC'))
      end
    end
  end
end
