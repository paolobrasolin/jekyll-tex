# frozen_string_literal: true

require 'jekyll/antex/block'
require 'jekyll_helper'

describe Jekyll::Antex::Block do
  setup_tmpdir

  describe 'jekyll integration' do
    context 'writing a page' do
      setup_site

      setup_page <<~'SOURCE'
        ---
        This is my first {% antex %}\TeX{% endantex %} paragraph.
      SOURCE

      before do
        site.setup
        site.read
        # NOTE: we deliberately omit generation
        #   in order to test only the rendering
        # site.generate
      end

      it 'renders matched regexp with typeset image' do
        expect { site.render }
          .to change { site.pages.first.content }
          .from(<<~'READ').to(include <<~'RENDERED')
            ---
            This is my first {% antex %}\TeX{% endantex %} paragraph.
        READ
            <p>This is my first <span class="antex"><img style="margin: 0.001ex 0.056ex -0.5ex 0.0ex; height: 2.086ex; width: 4.267ex;" src="/antex/c0e86f842cc44de5acca550f5449d23d.svg" /></span> paragraph.</p>
        RENDERED
      end

      it 'includes rendered image into static files' do
        expect { site.render }
          .to change { site.static_files.length }.by 1
      end
    end

    context 'writing a post' do
      setup_site

      setup_post <<~'SOURCE'
        ---
        This is my first {% antex %}\TeX{% endantex %} paragraph.
      SOURCE

      before do
        site.setup
        site.read
        # NOTE: we deliberately omit generation
        #   in order to test only the rendering
        # site.generate
      end

      it 'renders matched regexp with typeset image' do
        expect { site.render }
          .to change { site.posts.first.content }
          .from(<<~'READ').to(include <<~'RENDERED')
            ---
            This is my first {% antex %}\TeX{% endantex %} paragraph.
        READ
            <p>This is my first <span class="antex"><img style="margin: 0.001ex 0.056ex -0.5ex 0.0ex; height: 2.086ex; width: 4.267ex;" src="/antex/c0e86f842cc44de5acca550f5449d23d.svg" /></span> paragraph.</p>
        RENDERED
      end

      it 'includes rendered image into static files' do
        expect { site.render }
          .to change { site.static_files.length }.by 1
      end
    end
  end
end