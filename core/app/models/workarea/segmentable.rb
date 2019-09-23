module Workarea
  module Segmentable
    extend ActiveSupport::Concern

    included do
      field :active_by_segment, type: Hash, default: {}, localize: true
      before_save :typecast_active_by_segment
    end

    class_methods do
      def active
        if embedded?
          scoped.select(&:active?)
        else
          Workarea.deprecation.warn(
            <<~eos.squish
              The active scope is being called on a root document. This won't
              respect segments. Rewrite this to use #active?, like: scope.select(&:active?)
            eos
          )
          scoped.where(active: true)
        end
      end

      def inactive
        if embedded?
          scoped.reject(&:active?)
        else
          Workarea.deprecation.warn(
            <<~eos.squish
              The inactive scope is being called on a root document. This won't
              respect segments. Rewrite this to use !#active?, like: scope.reject(&:active?)
            eos
          )
          scoped.where(active: false)
        end
      end
    end

    def active?
      default = super
      return default if active_by_segment.blank?

      segment = Segment.current.detect { |s| active_by_segment.key?(s.id.to_s) }
      return default if segment.blank?

      active_by_segment[segment.id.to_s]
    end

    def active_segment_ids
      active_by_segment.select { |_, v| v }.keys
    end

    def active_segment_ids=(ids)
      replace_active_by_segment(replace: true, with: ids)
    end

    def inactive_segment_ids
      active_by_segment.reject { |_, v| v }.keys
    end

    def inactive_segment_ids=(ids)
      replace_active_by_segment(replace: false, with: ids)
    end

    private

    def typecast_active_by_segment
      type = ActiveModel::Type::Boolean.new

      self.active_by_segment = active_by_segment
        .reject { |k, v| v != false && v.blank? } # :(
        .transform_keys(&:to_s)
        .transform_values { |v| type.cast(v) }
    end

    def replace_active_by_segment(replace:, with:)
      current = active_by_segment.reject { |_, v| v == replace }
      new_values = with.reject(&:blank?).reduce(current) { |m, id| m.merge(id => replace) }
      self.active_by_segment = new_values
    end
  end
end
