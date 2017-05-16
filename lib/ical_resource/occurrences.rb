# frozen_string_literal: true

require 'http'
require 'icalendar/recurrence'

module IcalResource
  EventOccurrence = Struct.new(:event, :occurrence)

  class Occurrences
    def initialize(calendar)
      @calendar = calendar
    end

    def within(range)
      @calendar.events.map do |event|
        event.occurrences_between(range.begin, range.end).map do |occurrence|
          EventOccurrence.new(event, occurrence)
        end
      end.
        flatten.
        compact.
        sort_by { |eo| eo.occurrence.start_time }
    end
  end
end
