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

    it 'all have an event' do
      expect(occurrences).to all(satisfy(&:event))
      expect(occurrences).to all(satisfy { |eo| !eo.event.summary.empty? })
      expect(occurrences).to all(satisfy { |eo| !eo.event.description.empty? })
      expect(occurrences).to all(satisfy { |eo| !eo.event.location.empty? })
    end

    it 'all have an occurrence' do
      expect(occurrences).to all(satisfy(&:occurrence))
      expect(occurrences).to all(satisfy { |eo| eo.occurrence.start_time })
      expect(occurrences).to all(satisfy { |eo| eo.occurrence.end_time })
    end

    it 'all have an uid' do
      expect(occurrences).to all(satisfy(&:uid))
    end
  end

  context 'in May 2017' do
    let(:range) { Time.utc(2017, 5, 1, 0, 0, 0)..Time.utc(2017, 5, 31, 23, 59, 59) }

    it 'happen three times' do
      expect(occurrences.size).to eq(3)
    end

    it 'all three occurrences have different start times' do
      expect(occurrences[0].occurrence.start_time).to_not eq(occurrences[1].occurrence.start_time)
      expect(occurrences[1].occurrence.start_time).to_not eq(occurrences[2].occurrence.start_time)
      expect(occurrences[2].occurrence.start_time).to_not eq(occurrences[0].occurrence.start_time)
    end

    it 'all three occurrences have different end times' do
      expect(occurrences[0].occurrence.end_time).to_not eq(occurrences[1].occurrence.end_time)
      expect(occurrences[1].occurrence.end_time).to_not eq(occurrences[2].occurrence.end_time)
      expect(occurrences[2].occurrence.end_time).to_not eq(occurrences[0].occurrence.end_time)
    end

    it 'all three occurrences have different uids' do
      expect(occurrences[0].uid.to_s).to_not eq(occurrences[1].uid.to_s)
      expect(occurrences[1].uid.to_s).to_not eq(occurrences[2].uid.to_s)
      expect(occurrences[2].uid.to_s).to_not eq(occurrences[0].uid.to_s)
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
