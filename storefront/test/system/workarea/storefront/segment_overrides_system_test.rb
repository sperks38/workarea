require 'test_helper'

module Workarea
  module Storefront
    class SegmentOverridesSystemTest < Workarea::SystemTest
      def test_previewing_a_segment
        set_current_user(create_user(super_admin: true))
        segment_one = create_segment(name: 'One', position: 0, rules: [])
        segment_two = create_segment(name: 'Two', position: 1, rules: [])

        content = Content.for('home_page')
        content.blocks.create!(
          type: 'html',
          data: { 'html' => '<p>Foo</p>' },
          active_by_segment: { segment_one.id => false }
        )
        content.blocks.create!(
          type: 'html',
          data: { 'html' => '<p>Bar</p>' },
          active_by_segment: { segment_two.id => false }
        )

        visit storefront.root_path
        assert_content('Foo')
        assert_content('Bar')

        within_frame find('.admin-toolbar') do
          select 'One', from: 'segment_id'
        end
        assert_no_content('Foo')
        assert_content('Bar')

        within_frame find('.admin-toolbar') do
          select 'Two', from: 'segment_id'
        end
        assert_content('Foo')
        assert_no_content('Bar')

        within_frame find('.admin-toolbar') do
          select t('workarea.admin.segments.select.reset'), from: 'segment_id'
        end
        assert_content('Foo')
        assert_content('Bar')
      end
    end
  end
end
