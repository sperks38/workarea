require 'test_helper'

module Workarea
  module Admin
    class SegmentOverridesIntegrationTest < Workarea::IntegrationTest
      include Admin::IntegrationTest

      def test_creates_segment_overrides
        segment = create_segment
        post admin.segment_override_path, params: { segment_id: segment.id, return_to: '/foo' }
        assert_equal([segment.id], session[:segment_ids])
        assert_redirected_to('/foo')

        post admin.segment_override_path, params: { segment_id: '' }
        assert_nil(session[:segment_ids])
        assert_redirected_to(storefront.root_path)
      end
    end
  end
end
