# frozen_string_literal: true

require 'jekyll_helper'

describe Jekyll::Antex::Dealiaser do
  setup_tmpdir

  describe 'definition of custom aliases' do
    setup_site

    setup_config <<~'CONFIG'
      antex:
        aliases:
          test_alias:
            priority: 7777777
            regexp: !ruby/regexp |
              /foo(?<code>.*?)bar/
    CONFIG

    setup_page <<~'SOURCE'
      ---
      Before fooSTUFFbar after.
    SOURCE

    before do
      site.setup
      site.read
    end

    let(:page) { site.pages.first }

    it 'dealiases custom alias as an "antex" liquid tag' do
      expect { Jekyll::Hooks.trigger :pages, :pre_render, page }
        .to change { page.content }
        .from(<<~'READ').to(<<~'GENERATED')
          ---
          Before fooSTUFFbar after.
      READ
          ---
          Before {% antex --- {}
           %}STUFF{% endantex %} after.
      GENERATED
    end
  end
end
