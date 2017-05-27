# frozen_string_literal: true
require 'concourse/resource/serializer'
require 'concourse/resource/errors'

module Concourse
  module Resource
    module ICal
      class In
        def initialize(destination_directory)
          raise ArgumentError.new('No destination directory given') if destination_directory.nil?
          @serializer = Serializer.new(destination_directory)
        end

        def call(source, version, params=nil)
          version = Time.parse(version.fetch('pubDate'))
          url = source.fetch('url')

          feed = Feed.new(url)
          item = feed.items_at(version).first
          raise VersionUnavailable.new(version, source) if item.nil?

          @serializer.serialize(item)

          {
            'version'  => { 'pubDate' => item.pubDate },
            'metadata' => [
              { 'name' => 'title', 'value' => item.title },
              { 'name' => 'description', 'value' => item.description },
            ]
          }
        end
      end
    end
  end
end
