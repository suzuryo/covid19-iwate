# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/SelfDisclosuresCard'

describe 'iPhone 6/7/8', type: :feature do
  LOCALES.each do |lang, data|
    context "page #{data[:path]}" do
      before do
        visit data[:path]
        page.scroll_to('.v-tabs')
        find('#app .v-tabs .v-slide-group__content a[href="#tab-1"]').click
        render_lazy_contents
        page.scroll_to('#SelfDisclosuresCard')
      end

      describe '自主公表(SelfDisclosuresCard)' do
        it '項目の値' do
          has_self_disclosures_card(lang: lang, lang_json: data[:json])
          has_no_breadcrumbs(id: '#SelfDisclosuresCard')
        end
      end
    end
  end
end
