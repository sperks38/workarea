require 'test_helper'

module Workarea
  class Segment
    class CollectionTest < TestCase
      def test_sorting
        one = create_segment(position: 0)
        two = create_segment(position: 1)
        three = create_segment(position: 2)

        collection = Collection.new(one, three, two)
        assert_equal([one, two, three], collection)
      end

      def test_prioritized_before
        one = create_segment(position: 0)
        two = create_segment(position: 1)
        three = create_segment(position: 2)

        collection = Collection.new(one, three, two)
        assert_equal([], collection.prioritized_before(one))
        assert_equal([one], collection.prioritized_before(two))
        assert_equal([one, two], collection.prioritized_before(three))
      end
    end
  end
end
