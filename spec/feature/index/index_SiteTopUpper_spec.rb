# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/SiteTopUpper'

describe 'iPhone 6/7/8', type: :feature do
  LOCALES.each do |lang, data|
    context "page #{data[:path]}" do
      before do
        visit data[:path]
        render_lazy_contents
        page.scroll_to('.pageTitle')
      end

      describe 'ページ上部 (SiteTopUpper)' do
        it '項目の値' do
          has_site_top_upper(lang: lang, data: data)
        end
      end
    end
  end
end
