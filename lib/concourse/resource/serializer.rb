# frozen_string_literal: true

module Concourse
  module Resource
    class Serializer
      def initialize(directory)
        @directory = directory
      end

      def serialize(item)
        item.class.serializable_attributes.each do |attribute|
          File.write(File.join(@directory, attribute), item.send(attribute))
        end
      end
    end
  end
end
