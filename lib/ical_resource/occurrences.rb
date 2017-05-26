# frozen_string_literal: true

require 'http'
require 'icalendar/recurrence'
require 'digest'

module IcalResource
  EventOccurrence = Struct.new(:event, :occurrence) do
    def uid
      "#{event.uid}##{occurrence.uid}"
    end
  end

  module WithUid
    #
    # An occurrence is a value object, so we build it's UID from
    # it's most important attributes; which are start_time and
    # end_time.
    #
    def uid
      Digest::SHA256.hexdigest("#{start_time}-#{end_time}")
    end
  end

  class Occurrences
    def initialize(calendar)
      @calendar = calendar
    end

    def within(range)
      @calendar.events.map do |event|
        event.occurrences_between(range.begin, range.end).map do |occurrence|
          EventOccurrence.new(event, occurrence.extend(WithUid))
        end
      end.
        flatten.
        compact.
        sort_by { |eo| eo.occurrence.start_time }
    end
  end
end
