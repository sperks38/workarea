module Workarea
  class Segment
    class Collection
      include Enumerable
      delegate_missing_to :to_a

      def initialize(*segments)
        @segments = segments
      end

      def to_a
        @to_a ||= Array.wrap(@segments).flatten.sort_by(&:position)
      end

      def prioritized_before(segment)
        take(index(segment))
      end
    end
  end
end
