# frozen_string_literal: true
require 'spec_helper'
require_relative '../../lib/SiteTopUpper'

describe "iPhone 6/7/8", type: :feature do
  context 'page [/]' do
    before do
      visit '/'
      render_lazy_contents
      page.scroll_to('.pageTitle')
    end

    describe 'ページ上部 (SiteTopUpper)' do
      it '項目の値' do
        has_site_top_upper
      end
    end
  end

  context 'page [/en]' do
    before do
      visit '/en'
      render_lazy_contents
      page.scroll_to('.pageTitle')
    end

    describe 'ページ上部 (SiteTopUpper)' do
      it '項目の値' do
        has_site_top_upper(locale: 'en')
      end
    end
  end

end
