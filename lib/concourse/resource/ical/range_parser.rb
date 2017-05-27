# frozen_string_literal: true

module IcalResource
  class RangeParser
    class InvalidRangeError < StandardError
      def initialize(invalid_range_spec)
        super("Invalid range spec: #{invalid_range_spec}")
      end
    end

    class << self
      def parse(spec)
        translated_spec = spec.tr(' ', '_')

        if self.respond_to?(translated_spec)
          self.public_send(translated_spec)
        else
          raise InvalidRangeError.new(spec)
        end
      end

      def today
        whole_day(Time.now.utc)
      end

      def yesterday
        whole_day(Time.now.utc - 60 * 60 * 24)
      end

      def this_month
        now = Time.now.utc
        whole_month(now.year, now.month)
      end

      def this_year
        whole_year(Time.now.year)
      end

      private

      def whole_day(day)
        beginning = Time.utc(day.year, day.month, day.day, 0, 0, 0)
        ending    = Time.utc(day.year, day.month, day.day, 23, 59, 59)
        beginning..ending
      end

      def whole_month(year, month)
        beginning = Time.utc(year, month, 1, 0, 0, 0)
        ending    = Time.utc(year, month, last_day_of_month(year, month), 23, 59, 59)
        beginning..ending
      end

      def whole_year(year)
        beginning = Time.utc(year, 1,  1, 0, 0, 0)
        ending    = Time.utc(year, 12, 31, 23, 59, 59)
        beginning..ending
      end

      def last_day_of_month(year, month)
        Date.new(year, month, -1).day
      end
    end
  end
end
