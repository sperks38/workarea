require 'test_helper'

module Workarea
  module Admin
    class SegmentsIntegrationTest < Workarea::IntegrationTest
      include Admin::IntegrationTest

      def test_update
        segment = create_segment(name: 'Custom Segment')
        patch admin.segment_path(segment), params: { segment: { name: 'foo bar' } }

        assert_equal(1, Segment.count)
        assert_equal('foo bar', Segment.first.name)
      end

      def test_moving
        segment_one = create_segment(position: 1)
        segment_two = create_segment(position: 2)
        segment_three = create_segment(position: 3)

        post admin.move_segments_path,
          params: {
            positions: {
              segment_three.id => 0,
              segment_two.id => 1,
              segment_one.id => 2
            }
          }

        assert_equal(0, segment_three.reload.position)
        assert_equal(1, segment_two.reload.position)
        assert_equal(2, segment_one.reload.position)
      end

      def test_destroy
        segment = create_segment(name: 'Custom Segment')
        delete admin.segment_path(segment)
        assert_equal(0, Segment.count)

        create_life_cycle_segments
        life_cycle = Segment::LoyalCustomer.first

        assert_no_difference 'Segment.count' do
          delete admin.segment_path(life_cycle)
          assert_equal(204, response.status)
        end
      end
    end
  end
end
