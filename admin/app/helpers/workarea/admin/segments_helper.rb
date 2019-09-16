module Workarea
  module Admin
    module SegmentsHelper
      def segment_rule_types_options
        Workarea.config.segment_rule_types.map do |string|
          rule = string.constantize
          [t("workarea.admin.fields.#{rule.slug}", default: rule.slug.to_s), rule.slug]
        end
      end

      def traffic_referrer_medium_options
        {
          t('workarea.admin.segment_rules.unknown') => 'unknown',
          t('workarea.admin.segment_rules.email') => 'email',
          t('workarea.admin.segment_rules.social') => 'social',
          t('workarea.admin.segment_rules.search') => 'search'
        }
      end

      def segments
        @segments ||= Segment.all
      end

      def active_by_segment_options
        {
          '-' => nil,
          t('workarea.admin.fields.active') => 'true',
          t('workarea.admin.fields.inactive') => 'false'
        }
      end

      def segment_options_for_select
        selected = segments.detect { |s| s.id.in?(current_segments.map(&:id)) }
        results = segments.map { |r| [r.name, r.id] }
        results.unshift([t('workarea.admin.segments.select.reset'), nil])
        options_for_select(results, selected&.id)
      end
    end
  end
end
