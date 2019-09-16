module Workarea
  module Admin
    class SegmentOverridesController < Admin::ApplicationController
      def create
        segments = Segment.in(id: Array.wrap(params[:segment_id]))
        self.override_segments = segments

        if params[:return_to].present?
          redirect_to URI.parse(params[:return_to]).request_uri
        else
          redirect_back fallback_location: storefront.root_path
        end
      end
    end
  end
end
