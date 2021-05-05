# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/PositiveRateCard'

describe 'iPhone 6/7/8', type: :feature do
  LOCALES.each do |lang, data|
    context "page #{data[:path]}" do
      before do
        visit data[:path]
        render_lazy_contents
        page.scroll_to('#PositiveRateCard')
      end

      describe '検査の陽性率(PositiveRateCard)' do
        it '項目の値' do
          has_positive_rate_card(lang: lang, lang_json: data[:json])
          has_no_breadcrumbs(id: '#PositiveRateCard')
        end
      end
    end
  end
end
